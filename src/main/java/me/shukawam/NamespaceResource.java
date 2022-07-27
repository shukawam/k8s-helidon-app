package me.shukawam;

import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.json.Json;
import jakarta.json.JsonBuilderFactory;
import jakarta.json.JsonObject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import java.util.Collections;

/**
 * @author shukawam
 */
@Path("/namespace")
@RequestScoped
public class NamespaceResource {
    private static final JsonBuilderFactory JSON = Json.createBuilderFactory(Collections.emptyMap());
    private final NamespaceProvider namespaceProvider;

    @Inject
    public NamespaceResource(NamespaceProvider namespaceProvider) {
        this.namespaceProvider = namespaceProvider;
    }

    @GET
    @Path("/")
    public JsonObject getNamespace() {
        return JSON.createObjectBuilder()
                .add("namespace", namespaceProvider.getNamespace())
                .build();
    }
}
