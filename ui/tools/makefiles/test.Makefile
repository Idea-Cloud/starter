########################################################################################################################
#
# TEST
#
########################################################################################################################

test: check-lint test-unit

check-lint:
	@make make-in-node MAKE_RULE=_check-lint

_check-lint:
	@echo "${YELLOW}Checking code rules (linters)${RESET}"
	@${NODE_MODULES_BIN}/eslint --cache-location .eslintcache --color ${FIX} --ext js,vue ./src${args} ./tests

lint:
	@make make-in-node LOCAL_ENV="FIX=--fix" MAKE_RULE=_check-lint

test-unit:
	@make make-in-node LOCAL_ENV="CI_TU='${CI_TU}'" MAKE_RULE=_test-unit

test-unit-watch:
	@make make-in-node LOCAL_ENV="WATCH=--watch" MAKE_RULE=_test-unit

_test-unit:
	@echo "${YELLOW}Running unit tests${RESET}"
	@${NODE_MODULES_BIN}/vue-cli-service test:unit ${WATCH} ${CI_TU} tests/unit/${args}
