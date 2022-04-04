package me.shukawam;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.json.Json;
import javax.json.JsonBuilderFactory;
import javax.json.JsonObject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
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
