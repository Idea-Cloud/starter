#!/usr/bin/env bash

# setup 'strict mode'
set -euo pipefail
IFS=$'\n\t'
NO_DOCKER=${NO_DOCKER:=}

# Search it.only or test.only forgotten in test-unit files
set +e
grep -Eirn "^(\s+)?(it|test)\.only.*" --include=\*.spec.js ./ui/tests/unit
if [[ "$?" -eq 0 ]]; then
  exit 1
fi

grep -Eirn "^(\s+)?@pytest\.mark\.skip.*" --include=\*.py ./api/tests
if [[ "$?" -eq 0 ]]; then
  exit 1
fi
set -e

NO_DOCKER=${NO_DOCKER} make format

# Disallow unstaged changes in the working tree, stop here before running tests with uncommited files
if ! git diff --quiet --ignore-submodules
then
    echo >&2 "error: cannot push you have unstaged changes."
    git diff --name-status -r --ignore-submodules >&2
    exit 1
fi

# Linters and Test-unis are too long, ssh connection timeout in github is too short: "Connection to github.com closed by remote host."

#NO_DOCKER=${NO_DOCKER} make test
#if [[ "$?" -eq 0 ]]; then
#  exit 1
#fi

#exit 0
