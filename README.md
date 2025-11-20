📦 Robot-Shop Microservices Project — Complete DevOps Implementation

A fully containerized, production-grade microservices application deployed on AWS EKS using Helm, Argo CD, GitHub Actions, and complete observability (Prometheus, Grafana, FluentBit, Jaeger).
This project demonstrates real-world DevOps workflows, including CI/CD pipelines, infrastructure automation, monitoring, logging, and secure cloud deployments.

🚀 Project Overview

Robot-Shop is a cloud-native microservices application built using Node.js, Spring Boot, Python, Go, and NGINX for frontend delivery.
Each microservice runs independently and communicates over internal service discovery within Kubernetes.

This project demonstrates how to:

Containerize a complex multi-service system

Deploy it to AWS EKS using Helm charts

Manage deployments using GitOps with Argo CD

Automate CI pipelines using GitHub Actions (Docker Build + Push, Helm Lint, K8s validation)

Set up monitoring (Prometheus + Grafana)

Set up centralized logging (FluentBit → CloudWatch/ElasticSearch)

Implement distributed tracing with Jaeger

Manage persistent storage using EBS CSI Driver [There is Terraform folder including all these resources ]

Secure workloads with Kubernetes RBAC and IAM Roles for Service Accounts (IRSA)


🧩 Architecture/Workflow Diagram 













🔧 Technologies Used
DevOps / Cloud

AWS EKS (Elastic Kubernetes Service)

AWS EBS CSI Driver for persistent volumes

IAM Roles for Service Accounts (IRSA)

Argo CD (GitOps deployment)

GitHub Actions (CI pipeline)

Helm 3 (package + deploy all services)

Docker Hub (image registry)

Observability

Prometheus (Metrics)

Grafana (Dashboards)

FluentBit (Logs)

Jaeger (Distributed Tracing)

Databases

MongoDB

MySQL

Redis

RabbitMQ

🏗️ Microservices Breakdown
Service	Tech	Purpose
web	NGINX	Frontend + API reverse proxy
catalogue	Go	Returns product catalog
user	Node.js	User login & registration
cart	Node.js	Shopping cart functionality
shipping	Java Spring Boot	Shipping price calculation using MySQL
payment	Node.js + RabbitMQ	Payment processing
ratings	Python Flask	Rating storage and retrieval
dispatch	Python	Order dispatch simulation
loadgen	Python tool	Generates load for testing
mongodb	DB	Stores users, cart, catalogue
mysql	DB	Stores shipping cities & rates
redis	Cache	Caching for cart
rabbitmq	Broker	Payment event queue
🐳 Containerization

Each microservice has its own:

Dockerfile

Build context

docker-compose setup for local dev

All images are pushed to Docker Hub:

docker build -t shubhamxyz/catalogue .
docker push shubhamxyz/catalogue

☸️ Kubernetes Deployment

Everything is deployed using one Helm chart:

helm install robotshop . -n robot-shop --create-namespace

Includes:

✔ Deployments
✔ Services
✔ StatefulSets for databases
✔ Secrets
✔ ConfigMaps
✔ PVC + StorageClass (EBS)
✔ Probes
✔ Resources
✔ Autoscaling-ready structure

🗄️ Persistent Storage (EBS CSI Driver)

Since MongoDB, Redis, and MySQL require data persistence, the project uses:

gp2 StorageClass

Dynamic provisioning through aws-ebs-csi-driver

IRSA-bound service accounts with correct IAM policies

Example PVC:

storageClassName: gp2
accessModes:
  - ReadWriteOnce
resources:
  requests:
    storage: 2Gi

🔁 GitOps with Argo CD

Argo CD continuously watches your GitHub repo.

Whenever you push updates:

Argo CD syncs new manifests

Automatically upgrades workloads

Ensures the cluster always matches Git state

⚙️ CI Pipeline — GitHub Actions

GitHub Actions executes on every push:

Workflows included:

✔ Build & Push Docker Images
✔ Lint Helm Charts
✔ Kubernetes Manifest Validation
✔ Notify ArgoCD (optional webhook / auto-sync)

Sample workflow:

- name: Build and push image
  run: |
    docker build -t user:${{ github.sha }} .
    docker push user:${{ github.sha }}

📊 Monitoring – Prometheus & Grafana

You installed monitoring using Helm:

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prom prometheus-community/kube-prometheus-stack -n monitoring

Provides:

Node metrics

Pod metrics

Application endpoints (/metrics)

Custom dashboards

📜 Logging – FluentBit

You used FluentBit DaemonSet to collect logs from all containers and push to:

CloudWatch (or)

ElasticSearch

It captures:

App logs

Kubelet logs

NGINX logs

API logs

🔍 Tracing – Jaeger

Installed via Helm:

helm install jaeger jaegertracing/jaeger -n tracing


Used by:

payment

shipping

web (NGINX opentracing module)

Allows you to trace user requests through all microservices end-to-end.

🌐 Frontend Exposure (LoadBalancer)

Web service uses:

type: LoadBalancer
port: 8080


AWS assigns a public ALB / NLB, and that becomes your public frontend URL.

🧪 Load Testing

loadgen deployment continuously hits:

web:8080


to generate traffic to test scaling & monitoring.

🛠️ Local Development

Clone repo

Install Docker & kubectl

Start services locally:

docker-compose up --build


Access frontend:

http://localhost:8080

☸️ Production Deployment Steps (EKS)
1️⃣ Create EKS Cluster
eksctl create cluster ...

2️⃣ Install EBS CSI Driver
aws eks create-addon --cluster robot-shop-eks-cluster --addon-name aws-ebs-csi-driver

3️⃣ Setup IRSA Role

IAM role attached to:

serviceAccount: ebs-csi-controller-sa

4️⃣ Deploy the application
helm install robotshop . -n robot-shop

5️⃣ Verify pods
kubectl get pods -n robot-shop

6️⃣ Access frontend

Use the external LB:

kubectl get svc -n robot-shop

🧹 Cleanup
helm uninstall robotshop -n robot-shop
eksctl delete cluster --name robot-shop-eks-cluster

🏁 Conclusion

This project is a complete real-world DevOps + Cloud + Kubernetes demonstration including:

Production-grade microservices architecture

Full CI/CD

GitOps automation

Observability

Cloud-native persistent storage

Secure IAM integration

Helm-based deployments

Multi-service Dockerization

It showcases end-to-end skills expected from a DevOps Engineer, especially for interviews and portfolio.
           
