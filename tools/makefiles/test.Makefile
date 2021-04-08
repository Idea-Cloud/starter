########################################################################################################################
#
# TEST
#
########################################################################################################################

test: check-lint test-unit

check-lint:
	@cd ui && NO_DOCKER=${NO_DOCKER} make check-lint
	@cd api && NO_DOCKER=${NO_DOCKER} make check-lint

test-unit:
	@cd ui && NO_DOCKER=${NO_DOCKER} make test-unit
	@cd api && NO_DOCKER=${NO_DOCKER} make test-unit

format:
	@cd ui && NO_DOCKER=${NO_DOCKER} make format
	@cd api && NO_DOCKER=${NO_DOCKER} make format
