FROM maven:3.9.1-eclipse-temurin-20 as build
WORKDIR /helidon
ADD pom.xml .
RUN mvn package -Dmaven.test.skip -Declipselink.weave.skip
ADD src src
RUN mvn package -DskipTests
RUN echo "done!"

FROM eclipse-temurin:20-jdk
WORKDIR /helidon
COPY --from=build /helidon/target/k8s-helidon-app.jar ./
COPY --from=build /helidon/target/libs ./libs
CMD ["java", "--enable-preview" ,"-jar", "k8s-helidon-app.jar"]
EXPOSE 8080
