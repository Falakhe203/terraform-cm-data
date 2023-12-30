export TF_VAR_STAGE?=dev

TERRAFORM_VERSION=1.2.3
TERRAGRUNT_VERSION=V0.37.1

install-checkov:
	@echo "Installation and configuration of checkov"
	pip install checkov
	mkdir -p .reports/Terraform

install-flake8:
	@echo "Installation and configuration of flake8"
	pip install flake8

install-terraform:
	@echo "Installation and configuration of terraform"
	wget -q -o /tmp/terraform_{TERRAFORM_VERSION}_linux_amd64.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}
	unzip -o /tmp/terraform_{TERRAFORM_VERSION}_linux_amd64.zip -d /tmp && mv /tmp/terraform/usr/bin

install-terragrunt:
	@echo "Installation and configuration of terragrunt"
	wget -q -o /bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
	unzip -o /bin/terragrunt

install: install-flake8 install-checkov install-terraform install-terragrunt
@echo "Installation and configuration done"

checkov:
	@echo "Run checkov linting..."
	checkov --framework terraform -d . --config-file .checkov.yaml -o junitxml > .reports/terraform/checkov_results.xml

flake8:
	@echo "Run flake8 linting..."

terragrunt-init:
	@echo "Run terragrunt-init..."
	terragrunt init --terragrunt-non-interactive

terragrunt-plan: terragrunt-init
	@echo "Run terragrunt-plan..."
	terragrunt init --terragrunt-non-interactive -out=terraform.plan

terragrunt: terragrunt-plan
	@echo "Run terragrunt-apply..."
	terragrunt init --terragrunt-non-interactive -out=terraform.plan

bootstrap-init:
	@$(MAKE) -C bootstrap bootstrap-init

bootstrap-plan:
	@$(MAKE) -C bootstrap bootstrap-plan
 

bootstrap:
	@$(MAKE) -C bootstrap bootstrap


.PHONY: install-checkov install-flake8 install-terraform install-terragrunt \
	terragrunt-init terragrunt-plan terragrunt \
	bootstrap-init bootstrap-plan bootstrap-plan bootstrap