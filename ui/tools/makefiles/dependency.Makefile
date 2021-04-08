########################################################################################################################
#
# DEPENDENCY
#
########################################################################################################################

add:
	@make make-in-node MAKE_RULE=_add

add-dev:
	@make make-in-node LOCAL_ENV="DEV_DEPENDENCY=--save-dev" MAKE_RULE=_add

_add:
	@echo "${YELLOW}Installing ${args}${RESET}"
	@npm install ${DEV_DEPENDENCY} ${args}

remove:
	@make make-in-node MAKE_RULE=_remove

_remove:
	@echo "${YELLOW}Removing ${args}${RESET}"
	@npm remove ${args}
