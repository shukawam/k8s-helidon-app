FROM maven:3.9.2-eclipse-temurin-20 as build
WORKDIR /helidon
ADD pom.xml .
RUN mvn package -Dmaven.test.skip -Declipselink.weave.skip
ADD src src
RUN mvn package -DskipTests
RUN echo "done!"

FROM eclipse-temurin:21-jdk
WORKDIR /helidon
COPY --from=build /helidon/target/k8s-helidon-app.jar ./
COPY --from=build /helidon/target/libs ./libs
CMD ["java", "--enable-preview" ,"-jar", "k8s-helidon-app.jar"]
EXPOSE 8080
