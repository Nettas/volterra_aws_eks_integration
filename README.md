# Volterra_aws_eks_integration
Demo to Show How to Use Volterra to Publish and Protect Services/Applications from a AWS EKS Cluster

Need to format:
For VoltMesh EKS Pod Deployment
1. Deploy EKS Cluster with EKSCTL see directions in eks_cluster.txt file
2. Deploy Voltmesh Pod: (https://www.volterra.io/docs/how-to/site-management/create-k8s-site)
3. Validate HugePages are Enabled on Worker Nodes
4. Make necessary changes in voltmesh_eks_pod.yml (token, Lat/Long, Cluster Name)
5. Deploy voltmesh_eks_pod.yml (kubectl apply -f voltmesh_eks_pod.yml)
6. Makesure the vp-manager-0 pod is running (kubectl get pods -n ves-system)
7. Log into Volterra Console
8. Goto System -> Site management -> Registrations -> Click the Checkmark next to your site to approve site Registration
9. Goto EKS Cluster and Validate pods are running in ves-system namespace (kubectl get pods -n ves-system)
10. Goto VoltConsole and validate site is up, running, 100% Healthy
11. Deploy nginx web app (kubectl apply -f nginx_app.yml)
12. Terraform: Create Service Discovery for EKS Cluster in Volterra by running the terraform volterra_service.tf
    Make sure terraform.tfvars variables are updated
13. terraform init 
14. terraform validate
15. terraform fmt
16. terraform plan
17. terraform apply

