# EKS Setup

## EKS Clusters Creation and Setup

```bash
eksctl create cluster --name EKS-1 --region us-east-1
```

```bash
aws eks update-kubeconfig --name EKS-1 --region us-east-1
```

## EKS Clusters Deletion

```bash
eksctl delete cluster --name EKS-1 --region us-east-1
```
