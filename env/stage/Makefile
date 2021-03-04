.DEFAULT_GOAL := deploy

export ENV 					:= stage
export TF_VAR_env			:= $(ENV)
export terragrunt   		?= terragrunt
export TF_DATA_DIR 			?= .terragrunt-cache
export TERRAGRUNT_DOWNLOAD 	?= $(TF_DATA_DIR)
export TF_LOG_PATH 			?= $(TF_DATA_DIR)/terraform.log
TFPLAN      	   			:= $(shell pwd)/$(TF_DATA_DIR)/$(ENV).tfplan # terragrunt bug, requires absolute path


deploy: init plan apply wait-ready output 

undeploy: init destroy apply 

init:
	$(terragrunt) init -get=true $(TF_CLI_ARGS) -reconfigure -force-copy

apply:
	$(terragrunt) apply $(TF_CLI_ARGS) $(TFPLAN)

plan:
	$(terragrunt) plan $(TF_CLI_ARGS) -out=$(TFPLAN)

destroy: TF_CLI_ARGS:=-destroy $(TF_CLI_ARGS)
destroy: plan


output:
	$(terragrunt) output dns_elb
	$(eval SENTRY_DNS:=$(shell $(terragrunt) output dns_sentry_public))
	$(eval ELB_DNS:=$(shell $(terragrunt) output dns_elb))
	$(eval SENTRY_INTERNAL_DNS:=$(shell $(terragrunt) output dns_ec2_sentry_internal))
	$(eval SENTRY_EMAIL:=$(shell $(terragrunt) output sentry_email))
	$(eval SENTRY_PASSWORD:=$(shell $(terragrunt) output sentry_password))
	@echo
	@echo Outputs:
	@echo dns                 = $(SENTRY_DNS)
	@echo sentry_email 		  = $(SENTRY_EMAIL)
	@echo sentry_password     = $(SENTRY_PASSWORD)
	@echo
	@echo elb_dns             = $(ELB_DNS)
	@echo sentry_enternal_dns = $(SENTRY_INTERNAL_DNS)
	@echo

wait-ready: WAIT_TIMEOUT:=1200
wait-ready:
	$(eval URL:=$(shell $(terragrunt) output dns_sentry_public))
	$(eval timeout := $(shell echo "`date +%s` + $(WAIT_TIMEOUT)" | bc ))
	@ echo Waiting for '$(URL)' to respond ready
	@ while [ "`date +%s`" -le "$(timeout)" ]; do \
		code="`curl -kssLo /dev/null -w "%{http_code}" $(URL)`"; \
		if test "$$code" -eq "200"; then \
			exit 0; \
		fi; \
		echo "Still waiting..."; \
		sleep 2; \
	done; \
	echo "ERROR timeout $(WAIT_TIMEOUT)sec"; \
	exit 1