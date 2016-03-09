#!/bin/sh

# An example hook script to verify what is about to be pushed.  Called by "git
# push" after it has checked the remote status, but before anything has been
# pushed.  If this script exits with a non-zero status nothing will be pushed.
#
# This hook is called with the following parameters:
#
# $1 -- Name of the remote to which the push is being done
# $2 -- URL to which the push is being done
#
# If pushing without using a named remote those arguments will be equal.
#
# Information about the commits which are being pushed is supplied as lines to
# the standard input in the form:
#
#   <local ref> <local sha1> <remote ref> <remote sha1>
#
# This sample shows how to prevent push of commits where the log message starts
# with "WIP" (work in progress).

remote="$1"
url="$2"


# checks if branch has something pending
function parse_git_dirty() {
  git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo "*"
}

# gets the current git branch
function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# get last commit hash prepended with @ (i.e. @8a323d0)
function parse_git_hash() {
  git rev-parse --short HEAD 2> /dev/null | sed "s/\(.*\)/@\1/"
}

function parse_commit_message() {
    git log -1 HEAD --pretty=format:%s 2> /dev/null
}

function parse_user_name() {
    git log -1 --format=format:%an HEAD 2> /dev/null
}

function parse_user_email() {
    git log -1 --format=format:%ae HEAD 2> /dev/null
}

# DEMO
GIT_BRANCH=$(parse_git_branch)$(parse_git_hash)
GIT_COMMIT_MESSAGE=$(parse_commit_message)
GIT_COMMIT_USER_NAME=$(parse_user_name)
GIT_COMMIT_USER_EMAIL=$(parse_user_email)

echo ${GIT_BRANCH}
echo ${GIT_COMMIT_MESSAGE}
echo ${GIT_COMMIT_USER_NAME}
echo ${GIT_COMMIT_USER_EMAIL}

commit=grep 'Reviewed By' $GIT_COMMIT_MESSAGE 2> /dev/null

echo $commit

# Check for WIP commit
# 		commit=`git rev-list -n 1 --grep '^WIP' "$range"`
# 		if [ -n "$commit" ]
# 		then
# 			echo >&2 "Found WIP commit in $local_ref, not pushing"
# 			exit 1
# 		fi

# z40=0000000000000000000000000000000000000000
#
# while read local_ref local_sha remote_ref remote_sha
# do
# 	if [ "$local_sha" = $z40 ]
# 	then
# 		# Handle delete
# 		:
# 	else
# 		if [ "$remote_sha" = $z40 ]
# 		then
# 			# New branch, examine all commits
# 			range="$local_sha"
# 		else
# 			# Update to existing branch, examine new commits
# 			range="$remote_sha..$local_sha"
# 		fi
#
# 		# Check for WIP commit
# 		commit=`git rev-list -n 1 --grep '^WIP' "$range"`
# 		if [ -n "$commit" ]
# 		then
# 			echo >&2 "Found WIP commit in $local_ref, not pushing"
# 			exit 1
# 		fi
# 	fi
# done

exit 0
