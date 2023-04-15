# Sherpany
This repository is designed to contain my resolution of Sherpany's code challange

## Infrastructure

### General

The infrastructure for Sherpollny is provisioned and managed through Terraform, a popular infrastructure-as-code (IaC) tool. The infrastructure is composed of a Virtual Private Cloud (VPC) with a CIDR range of 10.0.0.0/16 and is organized into nine subnets - three public, three private, and three database subnets.

Within the private subnets, an Amazon Elastic Kubernetes Service (EKS) cluster is provisioned, which is responsible for hosting and managing the application pods. The EKS cluster is deployed across the three private subnets, ensuring high availability and fault tolerance.
![image](https://user-images.githubusercontent.com/52529073/231918541-70551d3c-c3a9-428f-93dd-c8a3a128ca2d.png)

### External access
To enable external access to the application pods, an ingress service and network load balancer (NLB) are provisioned. The ingress service routes incoming requests to the appropriate pods based on the URL path, while the NLB distributes traffic across the nodes in the EKS cluster. DNS management is integrated into the infrastructure, with the sherpany.vitorcarvalho.es domain name being created and pointed to the NLB. 

#### SSL
SSL termination happens in the ingress-controllers and PKI certificates are requested by the cert-manager CRD.

Overall, the infrastructure is designed to be secure, scalable, and highly available. Terraform is used to ensure that the infrastructure is reproducible and can be managed easily.

### Remarks

 - For HA, the subnets are spread across AZs, and the NLB has a ENI in each of the 3 AZs. Due to that, cross AZ load balancing can occur, so it has to be enabled on the NLB level otherwise some requets to the nlb might fail. 

 - Nodes are divided into two node groups, one that uses on-demand instances and one that uses spot instances. Both are composed ASGs that automatically registers new instances to the load balancer. 
 
 - EKS control-plane is publicly exposed, which is not ideal in a production environment for obvious reasons. It is only like this because making it private would obligate a private connection between the CI system and my VPC.

## Docker images

Docker images (in that case just one image, the poll app) are built, scanned and release to the ECR private registry through the pipeline. I chose to make a few modifications to the source code of the poll app in order to remove some hard coded parameters and start using variables for those values.


## CI/CD Pipeline

Sherpollny uses a Continuous Integration and Continuous Deployment (CI/CD) pipeline to automate the build, test, and deployment process. The pipeline is defined in the `ci.yml` file located in the `.github/workflows` directory. The pipeline is triggered whenever code changes are pushed to the `main` branch or a pull request is opened against the `main` branch.

The pipeline is divided into several jobs, each responsible for a specific stage of the CI/CD process. The jobs run on an Ubuntu Linux runner hosted by GitHub.

![image](https://user-images.githubusercontent.com/52529073/231917416-5fc3497a-982a-4e2a-8bf2-48c729839ef9.png)


### Sanity

The `sanity` job runs a script that validates the Terraform configuration files in the `terraform/` directory. The validation script checks the syntax and formatting of the configuration files, ensuring that they comply with the best practices and guidelines. This job runs on both pull requests and the main branch.

### Terraform Plan

The `terraform_plan` job creates a plan of the changes to be made to the infrastructure based on the changes in the code. It then saves the plan as an artifact that can be used in later stages of the pipeline. This job runs only on the main branch after the `sanity` job completes.

### Terraform Assess

The `terraform_assess` job checks the cost of the infrastructure changes proposed by the Terraform plan created in the `terraform_plan` job. It generates a diff report using the Infracost tool and posts it as a comment on the pull request. This job runs only on pull requests after the `terraform_plan` job completes.

![image](https://user-images.githubusercontent.com/52529073/231917509-7cda0b77-3341-4d2a-92dd-8c3531431897.png)


### Terraform Apply

The `terraform_apply` job applies the changes to the infrastructure based on the Terraform plan created in the `terraform_plan` job. This job runs only on the main branch after the `terraform_plan` job completes.

### Build Image

The `build_image` job builds a Docker image for the Sherpany web application and saves it as an artifact that can be used in later stages of the pipeline. This job runs on both pull requests and the main branch.

### Scan Image

The `scan_image` job scans the Docker image built in the `build_image` job for security vulnerabilities using the Trivy tool. This job runs only on the main branch after the `build_image` job completes.

### Push Image

The `push_image` job pushes the Docker image built in the `build_image` job to the Amazon Elastic Container Registry (ECR) repository. This job runs only on the main branch after the `scan_image` job completes.

### Deploy

The `deploy` job deploys the Sherpany web application to the EKS Kubernetes cluster using Helm. This job runs only on the main branch after both the `push_image` and `terraform_apply` jobs complete.

## Secrets Management

Secrets are an important aspect of any infrastructure or application. In this project, we have two types of secrets: secrets related to the CI/CD pipeline and secrets related to the Kubernetes workloads.

### CI/CD Secrets

All the secrets related to the CI/CD pipeline, such as API keys and other sensitive information, are stored in GitHub Secrets. These secrets are encrypted and can only be accessed by authorized users or actions. The CI/CD pipeline uses these secrets to authenticate and interact with the necessary resources such as AWS.

### Kubernetes Secrets

Secrets related to the Kubernetes workloads are stored as Kubernetes Secrets, created by Terraform. These secrets are used to securely store sensitive information such as credentials used by the application running on Kubernetes. These secrets can only be accessed by authorized pods running in the same namespace as the secret.

## Backups

Backups are handled by [Velero](https://velero.io/), an OpenSource kubernetes cluster backup solution and restores are easily done through it's CLI, thus no need for an actual backup script.
