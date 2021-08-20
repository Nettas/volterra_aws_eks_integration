# Volterra_aws_eks_integration
Demo to Show How to Use Volterra to Publish and Protect Services/Applications from a AWS EKS Cluster

Need to format:
For VoltMesh EKS Pod Deployment
1. Deploy EKS Cluster with EKSCTL see directions in eks_cluster.txt file
2. Validate HugePages are Enabled on Worker Nodes
3. Make necessary changes in voltmesh_eks_pod.yml (token, Lat/Long, Cluster Name)
4. Deploy voltmesh_eks_pod.yml (kubectl apply -f voltmesh_eks_pod.yml)
5. Makesure the vp-manager-0 pod is running (kubectl get pods -n ves-system)
6. Log into Volterra Console
7. Goto System -> Site management -> Registrations -> Click the Checkmark next to your site to approve site Registration
8. Goto EKS Cluster and Validate pods are running in ves-system namespace (kubectl get pods -n ves-system)
9. Goto VoltConsole and validate site is up, running, 100% Healthy
10. Deploy nginx web app (kubectl apply -f nginx_app.yml)
11. Terraform: Create Service Discovery for EKS Cluster in Volterra by running the terraform volterra_service.tf
    Make sure terraform.tfvars variables are updated
12. terraform init 
13. terraform validate
14. terraform fmt
15. terraform plan
16. terraform apply

