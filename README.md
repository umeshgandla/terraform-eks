

# Terraform EKS Cluster (2-node setup)

This project uses **Terraform** to create an **Amazon EKS (Elastic Kubernetes Service)** cluster with:

- ✅ Custom VPC
- ✅ Public Subnets
- ✅ Internet Gateway and Routing
- ✅ EKS Cluster
- ✅ IAM roles for control plane and nodes
- ✅ 2 t3.medium EC2 Worker Nodes

---

## 🛠 Prerequisites

Make sure the following are installed **on your machine**:

1. **Terraform** → https://developer.hashicorp.com/terraform/downloads  
2. **AWS CLI** → https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html  
3. **kubectl** → https://kubernetes.io/docs/tasks/tools/

---


Terraform will:

Create all required AWS resources

Output the EKS cluster endpoint and kubeconfig


Once Terraform finishes, copy the kubeconfig output to your local kubeconfig file:

