FROM maven:3.5-jdk-8 AS build  
COPY src /usr/src/app/src  
COPY pom.xml /usr/src/app  
RUN mvn -f /usr/src/app/pom.xml clean package

FROM openjdk:8-jre-alpine 
COPY --from=build /usr/src/app/target/mongo-example-0.0.1-SNAPSHOT.jar /usr/app/mongo-example-0.0.1-SNAPSHOT.jar  
EXPOSE 6666  
ENTRYPOINT ["java","-jar","/usr/app/mongo-example-0.0.1-SNAPSHOT.jar"]  
