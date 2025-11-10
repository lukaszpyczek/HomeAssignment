SHELL := /bin/bash
ENV ?= dev


EKS_DIR = infra/aws
CHART_DIR := ./helm/hello-world
RELEASE_NAME := hello-world
NAMESPACE := hello-world-$(ENV)

pre-commit:
	pre-commit run --all-files

init:
	cd $(EKS_DIR) && terraform init

plan: init
	cd $(EKS_DIR) && terraform plan -var-file=envs/$(ENV).tfvars -out=tfplan


apply: plan
	cd $(EKS_DIR) && terraform apply -var-file=envs/$(ENV).tfvars -auto-approve tfplan

destroy:
	cd $(EKS_DIR) && terraform destroy -var-file=envs/$(ENV).tfvars --auto-approve

deploy-azure-hello:
	helm upgrade --install $(RELEASE_NAME) $(CHART_DIR) --namespace $(NAMESPACE) --create-namespace -f ./helm/hello-world/values-azure.yaml

deploy-aws-hello:
	helm upgrade --install $(RELEASE_NAME) $(CHART_DIR) --namespace $(NAMESPACE) --create-namespace -f ./helm/hello-world/values-aws.yaml
