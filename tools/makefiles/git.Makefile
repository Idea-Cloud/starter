########################################################################################################################
#
# GIT CONTROL & HOOKS
#
########################################################################################################################

rebase:
	@echo "${YELLOW}Rebasing ${CURRENT_GIT_BRANCH} with master${RESET}"
	@git stash \
	&& git pull --rebase \
	&& git checkout master \
	&& git pull --rebase \
	&& git checkout ${CURRENT_GIT_BRANCH} \
	&& git rebase master \
	&& git stash pop

pull:
	@echo "${YELLOW}Pulling ${CURRENT_GIT_BRANCH}${RESET}"
	@git stash \
	&& git pull --rebase \
	&& git stash pop

########################################################################################################################
#
# GIT HOOKS
#
########################################################################################################################

install-git-hooks:
	@ln -sf ../../tools/git-hooks/commit-msg.sh .git/hooks/commit-msg
	@ln -sf ../../tools/git-hooks/pre-push.sh .git/hooks/pre-push
