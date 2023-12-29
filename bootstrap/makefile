export TF_VAR_STAGE?=dev

bootstrap-init:
	@echo "Run terragrunt init for ${TF_VAR_STAGE}-environment bootstrap..."
	terragrunt init --terragrunt-non-interactive -reconfigure 

bootstrap-plan: bootstrap-init
	@echo "Run terragrunt plan for ${TF_VAR_STAGE}-environment bootstrap..."
	terragrunt plan --terragrunt-non-interactive -out=terraform.plan 

bootstrap: bootstrap-plan
	@echo "Run terragrunt init for ${TF_VAR_STAGE}-environment bootstrap..."
	terragrunt apply -auto-approve --terragrunt-non-interactive terraform.plan 

.PHONY: bootstrap-init bootstrap-plan bootstrap-apply