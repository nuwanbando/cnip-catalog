this is a WSO2 micro-ei container that runs a mock api without a backend

- to start the container ``docker run -d -p 8290:8290 -p 8253:8253 nuwanbando/hello-api-mock``
- to test the hello world service ``curl http://localhost:8290/hello``