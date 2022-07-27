package me.shukawam;

import org.eclipse.microprofile.config.inject.ConfigProperty;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import java.util.concurrent.atomic.AtomicReference;

/**
 * @author shukawam
 */
@ApplicationScoped
public class NamespaceProvider {
    private final AtomicReference<String> namespace = new AtomicReference<>();

    @Inject
    public NamespaceProvider(@ConfigProperty(name = "app.namespace") String namespace) {
        this.namespace.set(namespace);
    }

    public String getNamespace() {
        return namespace.get();
    }

    public void setNamespace(String namespace) {
        this.namespace.set(namespace);
    }
}
