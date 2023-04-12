#!/bin/bash

cd terraform/
terraform apply -input=false ../plan.out
