########################################################################################################################
#
# SETUP
#
########################################################################################################################

# Fix comes from https://github.com/docker/for-linux/issues/219
fix-fedora:
	sudo mkdir /sys/fs/cgroup/systemd
	sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd

setup:
#	@echo "${YELLOW}Login to AWS ECR${RESET}"
#	@${ECR_LOGIN_CMD}
	@make download-modd
	@echo "${YELLOW}Create docker-compose environnement${RESET}"
	@#--force-recreate --renew-anon-volumes
	@${DOCKER_COMPOSE} up --remove-orphans -d ${SERVICES} > /dev/null

	@make create-local-user-in-python
	@make create-local-user-in-node

build:
	@${DOCKER_COMPOSE} build --build-arg NODE_ENV="${NODE_ENV}" ${SERVICES}

build-%:
	@${DOCKER_COMPOSE} build --build-arg NODE_ENV="${NODE_ENV}" ${*}

clean: ##@setup Remove all components
	@echo "${YELLOW}Stop and remove docker-compose${RESET}"
	@make stop
	@${DOCKER_COMPOSE} rm -f

# aws sts get-session-token --serial-number arn:aws:iam::888041452335:mfa/gsick --token-code <code-generated-by-MFA-device>
# aws configure set aws_session_token <the-session-token-in-the-output-of-above-command>
#ecr:
#	AWS_PROFILE=ecr-toto aws ecr get-login-password \
#	--region ${ECR_AWS_REGION} \
#	| docker login \
#	--username AWS \
#	--password-stdin ${ECR_REGISTRY}
