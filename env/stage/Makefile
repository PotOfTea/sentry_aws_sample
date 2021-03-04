.DEFAULT_GOAL := deploy

export ENV 					:= stage
export TF_VAR_env			:= $(ENV)
export terragrunt   		?= terragrunt
export TF_DATA_DIR 			?= .terragrunt-cache
export TERRAGRUNT_DOWNLOAD 	?= $(TF_DATA_DIR)
export TF_LOG_PATH 			?= $(TF_DATA_DIR)/terraform.log
TFPLAN      	   			:= $(shell pwd)/$(TF_DATA_DIR)/$(ENV).tfplan # terragrunt bug, requires absolute path


deploy: init plan apply

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
	$(terragrunt) output  -json 
.PHONY: output