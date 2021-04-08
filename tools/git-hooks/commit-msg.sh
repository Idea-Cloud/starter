#!/usr/bin/env bash

# echo 1=$1
# echo 2=$2
# echo branch=$(git symbolic-ref HEAD)

COMMIT_MSG="$(cat "$1" | head -n 1 )"

# check if commit is merge commit or a commit ammend
if [ "$2" != "merge" ] && [ "$2" != "commit" ]; then

  # check if JIRA_ID-XXX is already in commit message
  if [[ ! $(echo "$COMMIT_MSG" | grep -E "([A-Z]{2,}-[0-9X]+)") ]]; then

    # check if JIRA_ID-XXX is in branch
    ISSUE_KEY=`git branch | grep -o "\* \(.*/\)*[A-Z]\{2,\}-[0-9]\+" | grep -o "[A-Z]\{2,\}-[0-9]\+"`
    if [ $? -ne 0 ]; then
        ISSUE_KEY="JIRA_ID-XXX"
    fi

    # issue key matched from branch prefix, prepend to commit message
    sed -i.back "1s/$/ - $ISSUE_KEY/" "$1"
  fi
fi


COMMIT_MSG=`cat $1 | sed -n 1p`
error_msg="\n Invalid commit message: ${COMMIT_MSG}\n> see https://github.com/.../wiki/commit-rules \n"

# check message length
LENGTH=`echo "${COMMIT_MSG}" | wc -c`

if [[ ${LENGTH} -gt 120 ]]; then
    echo -e "$error_msg" >&2;
    exit 1;
fi;

# check commint lint on type
commit_regex='^(feat|fix|docs|style|refactor|perf|test|chore)(\(.*\))?: (.+)$'

if ! grep -iqE "$commit_regex" "$1"; then
    echo -e "$error_msg" >&2
    exit 1
fi
