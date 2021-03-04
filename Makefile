.DEFAULT_GOAL := deploy

export terragrunt  ?= terragrunt
export TF_INPUT    := 0

deploy-%:
	$(MAKE) -C env/$* deploy
.PHONY: deploy-%

undeploy-%:
	$(MAKE) -C env/$* undeploy
.PHONY: undeploy-%



	