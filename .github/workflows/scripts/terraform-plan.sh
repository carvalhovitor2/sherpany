#!/bin/bash

cd terraform
terraform init
terraform plan -out=plan.out
