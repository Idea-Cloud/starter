########################################################################################################################
#
# HELPERS
#
########################################################################################################################

_%-should-be-up:
	@/bin/sh -c ' \
	    IS_UP=`${DOCKER_COMPOSE} ps ${*} | grep Up`; \
	    if [ -z "$${IS_UP}" ] ; \
	        then echo "${RED}${*} is down. You should start stack through make start${RESET}"; exit 1; \
	    fi \
	'

run-in-%:
    ifdef NO_DOCKER
		@${COMMAND}
    else
		@make _${*}-should-be-up
		@echo "${YELLOW}Running command in ${*}${RESET}"
		@${DOCKER_COMPOSE} exec --user ${LOCAL_USER_UID}:${LOCAL_USER_GID} --workdir ${DOCKER_WORKING_DIRECTORY} ${DOCKER_TTY} ${*} /bin/sh -c "${COMMAND}"
    endif

run-as-root-in-%:
    ifdef NO_DOCKER
		@${COMMAND}
    else
		@make _${*}-should-be-up
		@echo "${YELLOW}Running command in ${*}${RESET}"
		@${DOCKER_COMPOSE} exec --user 0:0 --workdir ${DOCKER_WORKING_DIRECTORY} ${DOCKER_TTY} ${*} /bin/sh -c "${COMMAND}"
    endif

make-in-%:
	@DOCKER_TTY=${DOCKER_TTY} make run-in-${*} COMMAND="${LOCAL_ENV} make ${MAKE_RULE} args='${args}'"

make-as-root-in-%:
	@DOCKER_TTY=${DOCKER_TTY} make run-as-root-in-${*} COMMAND="${LOCAL_ENV} make ${MAKE_RULE} args='${args}'"

create-local-user-in-%:
	@make make-as-root-in-${*} LOCAL_ENV="LOCAL_USER_UID=${LOCAL_USER_UID} LOCAL_USER_GID=${LOCAL_USER_GID} DATA_PATH_PREFIX=${DATA_PATH_PREFIX}" MAKE_RULE=_create-local-user-in-container

_create-local-user-in-container:
ifneq ("$(shell id -u user 3>&1 1>&2 2>&3 1> /dev/null; echo $${?})", "0")
	@echo "${YELLOW}Creating local user${RESET}"
	@mkdir -p /home/user
	@touch /home/user/.bashrc
	@chown -R ${LOCAL_USER_UID}:${LOCAL_USER_GID} /home/user
ifeq ($(OS), Darwin)
	@chown -R ${LOCAL_USER_UID}:${LOCAL_USER_GID} ${DATA_PATH_PREFIX}
endif
	@getent group ${LOCAL_USER_GID} 2>&1 > /dev/null || groupadd -g ${LOCAL_USER_GID} user
	@useradd -o -u ${LOCAL_USER_UID} -g ${LOCAL_USER_GID} -s /bin/sh --home-dir /home/user user
endif

download-modd: ##@helper Download modd watcher
	@mkdir -p ./bin
    ifeq ("$(wildcard ./bin/modd)","")
		@echo "${YELLOW}Downloading modd watcher v${MODD_VERSION}${RESET}"
        ifeq ($(OS), Darwin)
			@curl -L https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-osx64.tgz | tar xvf - --strip-components=1 -C ./bin
        endif
        ifeq ($(OS), Linux)
			@curl -L https://github.com/cortesi/modd/releases/download/v${MODD_VERSION}/modd-${MODD_VERSION}-linux64.tgz | tar zxvf - --strip-components=1 -C ./bin
        endif
    endif
