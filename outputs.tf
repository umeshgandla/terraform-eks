output "vpc_id" {
  value = aws_vpc.main.id
}
output "subnet_ids" {
  value = aws_subnet.public[*].id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubeconfig" {
  value = <<EOT
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority[0].data}
  name: eks-cluster
contexts:
- context:
    cluster: eks-cluster
    user: aws
  name: eks-cluster
current-context: eks-cluster
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "eks-cluster"
EOT
}