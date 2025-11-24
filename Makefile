SHELL := /bin/bash
ENV ?= dev


EKS_DIR = infra/aws
AKS_DIR = infra/azure
CHART_DIR := ./helm/hello-world
RELEASE_NAME := hello-world
NAMESPACE := hello-world-$(ENV)

pre-commit:
	pre-commit run --all-files

aws-init:
	cd $(EKS_DIR) && terraform init

aws-plan: aws-init
	cd $(EKS_DIR) && terraform plan -var-file=envs/$(ENV).tfvars -out=tfplan

aws-apply: aws-plan
	cd $(EKS_DIR) && terraform apply -var-file=envs/$(ENV).tfvars -auto-approve tfplan

aws-destroy:
	cd $(EKS_DIR) && terraform destroy -var-file=envs/$(ENV).tfvars --auto-approve

azure-init:
	cd $(AKS_DIR) && terraform init

azure-plan: azure-init
	cd $(AKS_DIR) && terraform plan -var-file=envs/$(ENV).tfvars -out=tfplan

azure-applly: azure-plan
	cd $(AKS_DIR) && terraform apply -var-file=envs/$(ENV).tfvars -auto-approve tfplan

azure-destroy:
	cd $(AKS_DIR) && terraform destroy -var-file=envs/$(ENV).tfvars --auto-approve

deploy-azure-hello:
	helm upgrade --install $(RELEASE_NAME) $(CHART_DIR) --namespace $(NAMESPACE) --create-namespace -f ./helm/hello-world/values-azure.yaml

deploy-aws-hello:
	helm upgrade --install $(RELEASE_NAME) $(CHART_DIR) --namespace $(NAMESPACE) --create-namespace -f ./helm/hello-world/values-aws.yaml
