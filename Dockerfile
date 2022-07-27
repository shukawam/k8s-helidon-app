
# 1st stage, build the app
FROM maven:3.8.6-openjdk-18 as build

WORKDIR /helidon

# Create a first layer to cache the "Maven World" in the local repository.
# Incremental docker builds will always resume after that, unless you update
# the pom
ADD pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn package -Dmaven.test.skip -Declipselink.weave.skip

# Do the Maven build!
# Incremental docker builds will resume here when you change sources
ADD src src
RUN mvn package
# RUN mvn package -DskipTests
RUN echo "done!"

# 2nd stage, build the runtime image
FROM openjdk:17.0.2
WORKDIR /helidon

# Copy the binary built in the 1st stage
COPY --from=build /helidon/target/k8s-helidon-app.jar ./
COPY --from=build /helidon/target/libs ./libs

CMD ["java", "-jar", "k8s-helidon-app.jar"]

EXPOSE 8080
