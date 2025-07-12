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


## Testing with docker compose

### logs from accounts:
2025-07-12T22:34:12.590Z  INFO [accounts,4b7c798f4bd2e6250e0a4bb90191612c,e383b607b00c4b6a] 1 --- [accounts] [nio-8080-exec-7] o.s.c.s.m.DirectWithAttributesChannel    : Channel 'accounts.sendCommunication-out-0' has 1 subscriber(s).
2025-07-12T22:34:12.591Z  INFO [accounts,4b7c798f4bd2e6250e0a4bb90191612c,e383b607b00c4b6a] 1 --- [accounts] [nio-8080-exec-7] o.s.c.s.binder.kafka.KafkaBinderMetrics  : Try to shutdown the old scheduler with 1 threads
2025-07-12T22:34:12.596Z  WARN [accounts,4b7c798f4bd2e6250e0a4bb90191612c,e383b607b00c4b6a] 1 --- [accounts] [nio-8080-exec-7] i.m.core.instrument.MeterRegistry        : This Gauge has been already registered (MeterId{name='spring.cloud.stream.binder.kafka.offset', tags=[tag(application=accounts),tag(group=accounts),tag(topic=communication-sent)]}), the registration will be ignored. Note that subsequent logs will be logged at debug level.
2025-07-12T22:34:13.933Z  INFO [accounts,,] 1 --- [accounts] [pool-9-thread-1] o.a.k.c.c.internals.ConsumerCoordinator  : [Consumer clientId=consumer-accounts-3, groupId=accounts] Found no committed offset for partition communication-sent-0
2025-07-12T22:34:13.939Z  INFO [accounts,1dc08cd96213fff175086aac769f9c24,7ba3733d75f85570] 1 --- [accounts] [pool-9-thread-1] o.a.k.c.c.internals.ConsumerCoordinator  : [Consumer clientId=consumer-accounts-3, groupId=accounts] Found no committed offset for partition communication-sent-0
2025-07-12T22:34:13.974Z  INFO [accounts,4b7c798f4bd2e6250e0a4bb90191612c,e383b607b00c4b6a] 1 --- [accounts] [nio-8080-exec-7] c.e.a.service.impl.AccountServiceImpl    : Is the communication request successfully triggered? : true
2025-07-12T22:34:14.743Z  INFO [accounts,4b7c798f4bd2e6250e0a4bb90191612c,1cfb37a6b2371f11] 1 --- [accounts] [container-0-C-1] c.e.accounts.functions.AccountFunctions  : Updating communication status for the account number: 1647021729
Hibernate: select a1_0.account_number,a1_0.account_type,a1_0.branch_address,a1_0.communication_sw,a1_0.created_at,a1_0.created_by,a1_0.customer_id,a1_0.updated_at,a1_0.updated_by from accounts a1_0 where a1_0.account_number=?
Hibernate: select a1_0.account_number,a1_0.account_type,a1_0.branch_address,a1_0.communication_sw,a1_0.created_at,a1_0.created_by,a1_0.customer_id,a1_0.updated_at,a1_0.updated_by from accounts a1_0 where a1_0.account_number=?
Hibernate: update accounts set account_type=?,branch_address=?,communication_sw=?,customer_id=?,updated_at=?,updated_by=? where account_number=?

### logs from message:
2025-07-12T22:25:25.379Z  INFO 1 --- [message] [container-0-C-1] o.a.k.c.c.internals.SubscriptionState    : [Consumer clientId=consumer-message-2, groupId=message] Resetting offset for partition send-communication-0 to position FetchPosition{offset=0, offsetEpoch=Optional.empty, currentLeader=LeaderAndEpoch{leader=Optional[kafka:9092 (id: 1 rack: null)], epoch=0}}.
2025-07-12T22:25:25.381Z  INFO 1 --- [message] [container-0-C-1] o.s.c.s.b.k.KafkaMessageChannelBinder$2  : message: partitions assigned: [send-communication-0]
2025-07-12T22:34:14.621Z  INFO 1 --- [message] [container-0-C-1] c.e.message.functions.MessageFunctions   : Sending email with the details : AccountsMsgDto[accountNumber=1647021729, name=Madan Reddy, email=tutor@eazybytes, mobileNumber=4354437688]
2025-07-12T22:34:14.628Z  INFO 1 --- [message] [container-0-C-1] c.e.message.functions.MessageFunctions   : Sending sms with the details : AccountsMsgDto[accountNumber=1647021729, name=Madan Reddy, email=tutor@eazybytes, mobileNumber=4354437688]
2025-07-12T22:34:22.799Z  INFO 1 --- [message] [container-0-C-1] org.apache.kafka.clients.NetworkClient   : [Consumer clientId=consumer-message-2, groupId=message] Node -1 disconnected.
2025-07-12T22:34:44.739Z  INFO 1 --- [message] [ad | producer-1] org.apache.kafka.clients.NetworkClient   : [Producer clientId=producer-1] Node -1 disconnected.

