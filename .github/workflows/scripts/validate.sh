#!/bin/bash

cd terraform

terraform init
terraform validate

terraform fmt -check=true -diff=true -recursive=true

terraform validate -var-file=terraform.tfvars
