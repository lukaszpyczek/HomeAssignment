SHELL := /bin/bash
ENV ?= dev

EKS_DIR = infra/aws

pre-commit:
	pre-commit run --all-files

init:
	cd $(EKS_DIR) && terraform init

plan: init
	cd $(EKS_DIR) && terraform plan -var-file=envs/$(ENV).tfvars -out=tfplan


apply: plan
	cd $(EKS_DIR) && terraform apply -var-file=envs/$(ENV).tfvar -auto-approve tfplan

destroy:
	cd $(EKS_DIR) && terraform destroy -var-file=envs/$(ENV).tfvar --auto-approve
