# Kubernetes Basic Assignment

## 1. Simple Spring Boot Web Application

A simple Spring Boot application that returns a welcome message.

```java
@RestController
public class HelloWorldController {

    @GetMapping("/")
    public String helloworld() {
        return "Welcome to Kubernetes";
    }
}
```
##  2. Dockerize the Application
A Dockerfile was created to containerize the application.
# Step 1: Create jar from Maven
 ```bash
FROM maven:3.8.3-openjdk-17-slim AS stage1
WORKDIR /home/app
COPY . /home/app
RUN mvn -f /home/app/pom.xml clean package -DskipTests
 ```

# Step 2: Create Docker image using the jar
 ```bash
FROM openjdk:17-jdk-slim
EXPOSE 8000
COPY --from=stage1 /home/app/target/kubernetesBasicDemo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["sh", "-c", "java -jar /app.jar"]
 ```


## 3. Build Docker Image
Go to the directory where the Dockerfile is located and run the following command to build the Docker image:
   ```bash
     docker build -t kubernetesbasic-app .
   ```
## 4. Verify Docker Image
 ```bash
     docker images
 ```

Expected output:
```bash
REPOSITORY                         TAG                     IMAGE ID       CREATED         SIZE
anandkoilwar/kubernetesbasic-app   latest                  5bce52fdb070   18 hours ago    428MB
kubernetesbasic-app                latest                  5bce52fdb070   18 hours ago    428MB

 ```
## 5. Push Image to DockerHub
```bash
    docker tag kubernetesbasic-app:latest anandkoilwar/kubernetesbasic-app:latest
    docker push anandkoilwar/kubernetesbasic-app:latest
 ```
# Deploy the Application to a Kubernetes Cluster
## 1. start minikube
```bash
     minikube start
```
## 2. Check Minikube Status
```bash
     minikube status
```
Expected output:
```bash
     minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

```
## 3. Create Deployment
Create a deployment.yaml file and apply it using:
```bash
     kubectl apply -f deployment.yaml
```
## 4. Verify Deployment and Pod

```bash
     kubectl get deployment
```
expected output:
```bash
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
kubernetesbasic-deployment   1/1     1            1           17h
nginx-depl                   1/1     1            1           23h
```
```bash
     kubectl get pod
```
expected output:
```bash
     NAME                                          READY   STATUS    RESTARTS   AGE
kubernetesbasic-deployment-7f68d68f67-5sm75   1/1     Running   0          16h
nginx-depl-5796b5c499-j8gmm                   1/1     Running   0          23h
```

## 5. Expose Deployment
Expose the deployment using a LoadBalancer:
```bash
     kubectl expose deployment kubernetesbasic-deployment --type=LoadBalancer --port=8000
```
## 6. Verify Services
```bash
     kubectl get service
```
Expected output:
```bash
NAME                         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
kubernetes                   ClusterIP      10.96.0.1      <none>        443/TCP          2d20h
kubernetesbasic-deployment   LoadBalancer   10.110.18.95   <pending>     8000:31095/TCP   19m
```
## 7. Access the Service
Run the following to open the service:
```bash
     minikube service kubernetesbasic-deployment
```
Expected output:
```bash
|-----------|----------------------------|-------------|---------------------------|
| NAMESPACE |            NAME            | TARGET PORT |            URL            |
|-----------|----------------------------|-------------|---------------------------|
| default   | kubernetesbasic-deployment |        8000 | http://192.168.49.2:31095 |
|-----------|----------------------------|-------------|---------------------------|
🏃  Starting tunnel for service kubernetesbasic-deployment.
|-----------|----------------------------|-------------|------------------------|
| NAMESPACE |            NAME            | TARGET PORT |          URL           |
|-----------|----------------------------|-------------|------------------------|
| default   | kubernetesbasic-deployment |             | http://127.0.0.1:39973 |
|-----------|----------------------------|-------------|------------------------|
🎉  Opening service default/kubernetesbasic-deployment in default browser...
👉  http://127.0.0.1:39973
❗  Because you are using a Docker driver on linux, the terminal needs to be open to run it.

```
## 8. hit the url in chrome browser http://127.0.0.1:39973 to see the output of the application


## 9. Scale the Application
run the below command to scale replica from 1 to 3.
```bash
     kubectl scale deployment kubernetesbasic-deployment --replicas=3
```

Check the statis of pod:
```bash
     kubectl get pod
```
Expected output:
```bash
NAME                                          READY   STATUS    RESTARTS   AGE
kubernetesbasic-deployment-7f68d68f67-22wf2   1/1     Running   0          12s
kubernetesbasic-deployment-7f68d68f67-5sm75   1/1     Running   0          17h
kubernetesbasic-deployment-7f68d68f67-vkwjj   1/1     Running   0          12s
nginx-depl-5796b5c499-j8gmm                   1/1     Running   0          23h
```










