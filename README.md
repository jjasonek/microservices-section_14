# Udemy Course Microservices with Spring Boot, Docker, Kubernetes Section_14
https://www.udemy.com/course/master-microservices-with-spring-docker-kubernetes/
## spring version: 3.4.5
## gatewayservice version: 3.5.0
## Java 21


## Documentation
After adding the library, the swagger page is accessible through address 
http://localhost:8080/swagger-ui/index.html,
http://localhost:8090/swagger-ui/index.html,
http://localhost:9000/swagger-ui/index.html.

## links

### Eureka Server dashboard
http://localhost:8070/

### Link from Eureka Server to Gateway Server
http://172.24.64.1:8072/actuator/info
{
    "app": {
        "name": "gatewayserver",
        "description": "Eazy Bank Gateway Server Application",
        "version": "1.0.0"
    }
}

### Further links
http://localhost:8072/actuator
http://localhost:8072/actuator/gateway
http://localhost:8072/actuator/gateway/routes

### Example invoking an service:
POST http://localhost:8072/eazybank/accounts/api/create


### actuator links:
http://localhost:8072/actuator
http://localhost:8071/actuator
http://localhost:8070/actuator
http://localhost:8080/actuator
http://localhost:8090/actuator
http://localhost:9000/actuator




## Docker compose

### for all microservices we call following to generate docker images s14:
mvn compile jib:dockerBuild

docker image ls --filter=reference="jjasonek/*:s14"

Alternatively you can use (on Linux):
docker images | grep s14

### push images to docker hub:
docker image push docker.io/jjasonek/accounts:s14
docker image push docker.io/jjasonek/loans:s14
docker image push docker.io/jjasonek/cards:s14
docker image push docker.io/jjasonek/message:s14
docker image push docker.io/jjasonek/configserver:s14
docker image push docker.io/jjasonek/eurekaserver:s14
docker image push docker.io/jjasonek/gatewayserver:s14

### Run docker compose:
docker-compose up -d

