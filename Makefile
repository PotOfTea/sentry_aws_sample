.DEFAULT_GOAL := deploy

export terragrunt  ?= terragrunt
export TF_INPUT    := 0

ifeq (, $(shell which terraform))
$(error "No terraform in $(PATH)")
endif

ifeq (, $(shell which terragrunt))
$(error "No terragrunt in $(PATH)")
endif

deploy-%:
	$(MAKE) -C env/$* deploy
.PHONY: deploy-%

undeploy-%:
	$(MAKE) -C env/$* undeploy
.PHONY: undeploy-%



	