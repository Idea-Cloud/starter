.PHONY:
.DEFAULT: help

MAKEFLAGS += --no-print-directory

############## Vars that can be edited ##############
ECR_AWS_REGION ?=
ECR_AWS_ACCOUNT_ID ?=

PYTHON_IMAGE := python:3.9.4-buster
NODE_IMAGE   := node:15.14.0-stretch
MODD_VERSION := 0.8

NODE_ENV ?= development
SERVICES ?= python node

############## Vars that shouldn't be edited ##############
OS               := $(shell uname)

LOCAL_USER_UID   ?= $(shell id -u)
LOCAL_USER_GID   ?= $(shell id -g)

CURRENT_GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

ROOT_DIR         ?= .
STACK_NAME       ?= starter

NODE_MODULES     ?= ./node_modules
NODE_MODULES_BIN ?= ${NODE_MODULES}/.bin

DOCKER_COMPOSE_FILE := ${ROOT_DIR}/docker-compose.yml
DATA_PATH_PREFIX    ?= /code

DOCKER_WORKING_DIRECTORY ?= ${DATA_PATH_PREFIX}
DOCKER_TTY ?= -T

ECR_REGISTRY ?= ${ECR_AWS_ACCOUNT_ID}.dkr.ecr.${ECR_AWS_REGION}.amazonaws.com
ECR_LOGIN_CMD := $(aws ecr get-login --no-include-email --registry-ids xxxxxxxxxxxx)

# env vars and command are separated to be able
# to inject others in between like this:
#
# ${DOCKER_COMPOSE_VARS} export MY_VAR=value; ${DOCKER_COMPOSE_CMD}
#
DOCKER_COMPOSE_VARS ?= export \
  PWD=${shell pwd -P} \
	LOCAL_USER_UID=${LOCAL_USER_UID} \
	LOCAL_USER_GID=${LOCAL_USER_GID} \
	STACK_NAME=${STACK_NAME} \
	PYTHON_IMAGE=${PYTHON_IMAGE} \
	NODE_IMAGE=${NODE_IMAGE} \
	DATA_PATH_PREFIX=${DATA_PATH_PREFIX} \
	NODE_ENV=${NODE_ENV};

DOCKER_COMPOSE_CMD ?= docker-compose -p ${STACK_NAME} -f ${DOCKER_COMPOSE_FILE}

DOCKER_COMPOSE     := ${DOCKER_COMPOSE_VARS} ${DOCKER_COMPOSE_CMD}
