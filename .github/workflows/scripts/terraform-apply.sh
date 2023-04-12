#!/bin/bash

cd terraform/
terraform init
terraform apply -input=false ../plan.out
