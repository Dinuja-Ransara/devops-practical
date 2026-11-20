@echo off
echo === Step 1: Syncing with GitHub (Dinuja-Ransara/devops-practical) ===
git init
git branch -M main
git remote remove origin 2>nul
git remote add origin https://github.com/Dinuja-Ransara/devops-practical.git
git add .
git commit -m "Update pipeline: Docker Hub image, dynamic PORT, and V2 tests"
git push -u origin main

echo === Step 2: Building and Pushing Docker Image (dinujaransara/flask-app:v1) ===
docker build -t flask-app:v1 .
docker tag flask-app:v1 dinujaransara/flask-app:v1
docker push dinujaransara/flask-app:v1

echo === Step 3: Starting Minikube (--driver=docker) and Deploying to Kubernetes ===
minikube start --driver=docker
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo === Waiting 10 seconds for Pods to start ===
timeout /t 10 /nobreak
kubectl get pods
minikube service flask-service
pause
