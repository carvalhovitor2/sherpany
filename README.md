# sherpollny
This repository is designed to contain my resolution of Sherpany's code challange

## Infrastructure

The infrastructure for Sherpollny is provisioned and managed through Terraform, a popular infrastructure-as-code (IaC) tool. The infrastructure is composed of a Virtual Private Cloud (VPC) with a CIDR range of 10.0.0.0/16 and is organized into nine subnets - three public, three private, and three database subnets.

Within the private subnets, an Amazon Elastic Kubernetes Service (EKS) cluster is provisioned, which is responsible for hosting and managing the application pods. The EKS cluster is deployed across the three private subnets, ensuring high availability and fault tolerance.

To enable external access to the application pods, an ingress service and network load balancer (NLB) are provisioned. The ingress service routes incoming requests to the appropriate pods based on the URL path, while the NLB distributes traffic across the nodes in the EKS cluster. DNS management is integrated into the infrastructure, with the sherpollny.vitorcarvalho.es domain name being created and pointed to the NLB.

Overall, the infrastructure is designed to be secure, scalable, and highly available. Terraform is used to ensure that the infrastructure is reproducible and can be managed easily.

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
