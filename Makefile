.DEFAULT_GOAL := deploy

export AWS_REGION  ?= eu-central-1
export terragrunt  ?= terragrunt
export TF_INPUT    := 0
export TERRAGRUNT_AUTO_INIT    := 0
export BUCKET_NAME ?= testing-reinis-as2

aws := aws

deploy-%:
	$(MAKE) -C env/$* deploy
.PHONY: deploy-%

undeploy-%:
	$(MAKE) -C env/$* undeploy
.PHONY: undeploy-%

# deploy-tf-bucket:
# 	$(aws) s3api head-bucket --bucket=$(BUCKET_NAME) || \
# 		$(aws) s3api create-bucket \
# 			--bucket=$(BUCKET_NAME) \
# 			--create-bucket-configuration LocationConstraint=$(AWS_REGION)  \
# 			--acl=private
# .PHONY: deploy-tf-bucket



	