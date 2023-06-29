import * as k8s from "@pulumi/kubernetes";

export interface Data {
  appName: string;
  namespace: string;
  deployment: {
    replicas: number;
    image: string;
    envs?: k8s.types.input.core.v1.EnvVar[];
  };
  ingress: {
    host: string;
    tls: {
      hosts: string[];
      secretName: string;
    };
  };
}
