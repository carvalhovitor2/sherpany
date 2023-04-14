# sherpollny
This repository is designed to contain my resolution of Sherpany's code challange

# Infrastructure

The infrastructure for Sherpollny is provisioned and managed through Terraform, a popular infrastructure-as-code (IaC) tool. The infrastructure is composed of a Virtual Private Cloud (VPC) with a CIDR range of 10.0.0.0/16 and is organized into nine subnets - three public, three private, and three database subnets.

Within the private subnets, an Amazon Elastic Kubernetes Service (EKS) cluster is provisioned, which is responsible for hosting and managing the application pods. The EKS cluster is deployed across the three private subnets, ensuring high availability and fault tolerance.

To enable external access to the application pods, an ingress service and network load balancer (NLB) are provisioned. The ingress service routes incoming requests to the appropriate pods based on the URL path, while the NLB distributes traffic across the nodes in the EKS cluster. DNS management is integrated into the infrastructure, with the sherpollny.vitorcarvalho.es domain name being created and pointed to the NLB.

Overall, the infrastructure is designed to be secure, scalable, and highly available. Terraform is used to ensure that the infrastructure is reproducible and can be managed easily.
