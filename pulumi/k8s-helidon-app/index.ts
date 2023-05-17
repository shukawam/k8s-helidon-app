import * as pulumi from "@pulumi/pulumi";
import * as k8s from "@pulumi/kubernetes";
import * as kx from "@pulumi/kubernetesx";

interface Data {
  namespace: string;
  deployment: {
    replicas: number;
  };
  ingress: {
    host: string;
    tls: {
      hosts: string[];
      secretName: string;
    };
  };
  cowweb: {
    message: string;
  };
}

let config = new pulumi.Config();
const data = config.requireObject<Data>("data");

const appName = "k8s-helidon-app";
const appLabels = { app: appName };

function defaultProbeGenerator(path: string) {
  return {
    httpGet: {
      path: path,
      port: "api",
    },
    initialDelaySeconds: 30,
    periodSeconds: 5,
  };
}

const deployment = new k8s.apps.v1.Deployment(appName, {
  kind: "Deployment",
  apiVersion: "apps/v1",
  metadata: {
    name: appName,
    namespace: data.namespace,
  },
  spec: {
    replicas: data.deployment.replicas,
    selector: { matchLabels: appLabels },
    template: {
      metadata: { labels: appLabels },
      spec: {
        containers: [
          {
            name: appName,
            image: `ghcr.io/shukawam/${appName}:latest`,
            imagePullPolicy: "IfNotPresent",
            ports: [{ name: "api", containerPort: 8080 }],
            readinessProbe: defaultProbeGenerator("/health/ready"),
            livenessProbe: defaultProbeGenerator("/health/live"),
            env: [{ name: "cowweb.message", value: data.cowweb.message }],
          },
        ],
        imagePullSecrets: [{ name: "ghcr-secret" }],
      },
    },
  },
});

const service = new k8s.core.v1.Service(appName, {
  kind: "Service",
  apiVersion: "v1",
  metadata: {
    name: appName,
    namespace: data.namespace,
    labels: {
      app: appName,
      "prometheus.io/scrape": "true",
    },
  },
  spec: {
    type: "ClusterIP",
    selector: appLabels,
    ports: [{ port: 8080, targetPort: 8080, name: "http" }],
  },
});

const ingress = new k8s.networking.v1.Ingress(appName, {
  kind: "Ingress",
  apiVersion: "networking.k8s.io/v1",
  metadata: {
    name: appName,
    namespace: data.namespace,
    annotations: {
      "kubernetes.io/ingress.class": "nginx",
      "cert-manager.io/cluster-issuer": "letsencrypt-prod",
    },
  },
  spec: {
    tls: [
      {
        hosts: data.ingress.tls.hosts,
        secretName: data.ingress.tls.secretName,
      },
    ],
    rules: [
      {
        host: data.ingress.tls.hosts[0],
        http: {
          paths: [
            {
              backend: {
                service: {
                  name: appName,
                  port: {
                    number: 8080,
                  },
                },
              },
              pathType: "Prefix",
              path: "/",
            },
          ],
        },
      },
    ],
  },
});

export const deploymentName = deployment.metadata.name;
export const serviceName = service.metadata.name;
export const ingressName = ingress.metadata.name;
