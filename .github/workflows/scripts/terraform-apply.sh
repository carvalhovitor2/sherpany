#!/bin/bash

cd terraform/
terraform init -upgrade
terraform apply -input=false ../plan.out
