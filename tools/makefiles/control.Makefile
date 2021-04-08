########################################################################################################################
#
# CONTROL
#
########################################################################################################################

# Can be /bin/sh
DEFAULT_SHELL := /bin/bash

shell-as-root:
	@make shell-as-root-app

shell-as-root-%:
	@make _${*}-should-be-up
	@${DOCKER_COMPOSE} exec --user root:root ${*} ${DEFAULT_SHELL}

shell:
	@make shell-app

shell-%:
	@make _${*}-should-be-up
	@${DOCKER_COMPOSE} exec --user ${LOCAL_USER_UID}:${LOCAL_USER_GID} ${*} ${DEFAULT_SHELL}

start-%:
	@${DOCKER_COMPOSE} start ${*}

start:
	@${DOCKER_COMPOSE} start ${TMP_SERVICES}

restart-%:
    ifdef QUICK
		@${DOCKER_COMPOSE} restart -t 0 ${*}
    else
		@${DOCKER_COMPOSE} restart ${*}
    endif

restart:
    ifdef QUICK
		@${DOCKER_COMPOSE} restart -t 0
    else
		@${DOCKER_COMPOSE} restart
    endif

stop:
    ifdef QUICK
		@${DOCKER_COMPOSE} stop -t 0
    else
		@${DOCKER_COMPOSE} stop
    endif

stop-%:
    ifdef QUICK
		@${DOCKER_COMPOSE} stop -t 0 ${*}
    else
		@${DOCKER_COMPOSE} stop ${*}
    endif

status:
	@${DOCKER_COMPOSE} ps

log-%:
	@${DOCKER_COMPOSE} logs --tail=$${TAIL_LENGTH:-50} -f ${*}

log:
	@${DOCKER_COMPOSE} logs -f --tail=$${TAIL_LENGTH:-50}

dump-log-%:
	@${DOCKER_COMPOSE} logs --tail=1000000 ${*}

reset:
	@make sync-docker-stack
	@make install
	@make QUICK=1 restart
