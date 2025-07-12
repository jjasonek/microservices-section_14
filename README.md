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

### Example invoking a service:
POST http://localhost:8072/eazybank/accounts/api/create


### actuator links:
http://localhost:8072/actuator
http://localhost:8071/actuator
http://localhost:8070/actuator
http://localhost:8080/actuator
http://localhost:8090/actuator
http://localhost:9000/actuator


## Testing

### run Redis server (not needed)
docker run -p 6379:6379 --name eazyredis -d redis
### start kafka
docker run -d --name microservices_kafka -p 9092:9092 apache/kafka:4.0.0
### start KeyCloak Docker container
docker run -d -p 127.0.0.1:7080:8080 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:26.3.0 start-dev


## Start services with kafka

2025-07-12T19:55:47.188+02:00  INFO 40320 --- [message] [           main] o.s.c.s.binder.DefaultBinderFactory      : Creating binder: kafka
2025-07-12T19:55:47.188+02:00  INFO 40320 --- [message] [           main] o.s.c.s.binder.DefaultBinderFactory      : Constructing binder child context for kafka
2025-07-12T19:55:47.343+02:00  INFO 40320 --- [message] [           main] o.s.c.s.binder.DefaultBinderFactory      : Caching the binder: kafka
2025-07-12T19:55:47.352+02:00  INFO 40320 --- [message] [           main] o.s.c.s.m.DirectWithAttributesChannel    : Channel 'message.emailsms-in-0' has 1 subscriber(s).
2025-07-12T19:55:47.443+02:00  INFO 40320 --- [message] [           main] figuration$IntegrationJmxConfiguration$1 : Registering MessageChannel errorChannel
2025-07-12T19:55:47.450+02:00  INFO 40320 --- [message] [           main] figuration$IntegrationJmxConfiguration$1 : Registering MessageChannel emailsms-in-0
2025-07-12T19:55:47.455+02:00  INFO 40320 --- [message] [           main] figuration$IntegrationJmxConfiguration$1 : Registering MessageChannel nullChannel
2025-07-12T19:55:47.456+02:00  INFO 40320 --- [message] [           main] figuration$IntegrationJmxConfiguration$1 : Registering MessageChannel emailsms-out-0
2025-07-12T19:55:47.462+02:00  INFO 40320 --- [message] [           main] figuration$IntegrationJmxConfiguration$1 : Registering MessageHandler _org.springframework.integration.errorLogger
2025-07-12T19:55:47.471+02:00  INFO 40320 --- [message] [           main] o.s.i.endpoint.EventDrivenConsumer       : Adding {logging-channel-adapter:_org.springframework.integration.errorLogger} as a subscriber to the 'errorChannel' channel
2025-07-12T19:55:47.471+02:00  INFO 40320 --- [message] [           main] o.s.i.channel.PublishSubscribeChannel    : Channel 'message.errorChannel' has 1 subscriber(s).
2025-07-12T19:55:47.471+02:00  INFO 40320 --- [message] [           main] o.s.i.endpoint.EventDrivenConsumer       : started bean '_org.springframework.integration.errorLogger'
2025-07-12T19:55:47.482+02:00  INFO 40320 --- [message] [           main] o.s.c.s.b.k.p.KafkaTopicProvisioner      : Using kafka topic for outbound: communication-sent
2025-07-12T19:55:47.486+02:00  INFO 40320 --- [message] [           main] o.a.k.clients.admin.AdminClientConfig    : AdminClientConfig values:
auto.include.jmx.reporter = true
...

### After POST http://localhost:8072/eazybank/accounts/api/create
WE should see message count changed in Kafka.
I saw: 
communication-sent: 4
send-communication: 1


## Docker compose

### for all microservices we call following to generate docker images s14:
mvn compile jib:dockerBuild
or .\RunMvnCommandForAllProjects.ps1 -MavenCommand "compile jib:dockerBuild"

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

