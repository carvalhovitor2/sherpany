#!/bin/bash

cd terraform
terraform init -upgrade
terraform plan -out=plan.out
terraform show -json plan.out > plan.json
