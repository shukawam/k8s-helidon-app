FROM maven:3.9.4-eclipse-temurin-21 as build
WORKDIR /helidon
ADD pom.xml .
RUN mvn package -Dmaven.test.skip -Declipselink.weave.skip
ADD src src
RUN mvn package -DskipTests
RUN echo "done!"

FROM eclipse-temurin:21.0.2_13-jdk
WORKDIR /helidon
COPY --from=build /helidon/target/k8s-helidon-app.jar ./
COPY --from=build /helidon/target/libs ./libs
CMD ["java", "-jar", "k8s-helidon-app.jar"]
EXPOSE 8080
