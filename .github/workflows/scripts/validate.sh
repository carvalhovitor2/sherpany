#!/bin/bash

cd terraform

terraform validate

terraform fmt -check=true -diff=true -recursive=true

terraform validate -var-file=my-variables.tfvars
