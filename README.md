SpringBoot with Linkerd Sidecar Application Service
====================================================

## Build the app
``./gradlew build``

## Run the app
``./gradlew bootRun``

## Package the app as an RPM
``./gradlew buildRpm``

## TEST
We use the env.local.test.yml file to run our tests

## Endpoints
This SpringBoot template application includes actuator library which will expose some default endpoints which can be used to monitor/measure the running application.

- Metrics:     http://localhost:8081/metrics
- Health:      http://localhost:8081/health
- Info:        http://localhost:8081/info
- Env Config:  http://localhost:8081/env
- Auto Config: http://localhost:8081/autoconfig

## Swagger 2
Swagger (version 2) is plugged into this application

- Access Swagger 2 UI:        [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html "Swagger UI")
- Access API in JSON format:  [http://localhost:8080/v2/api-docs?group=all](http://localhost:8080/v2/api-docs?group=all "API in JSON format")
- Toggle Swagger on/off in configuration using property``swagger.enabled``

