
#!/usr/bin/env bash
# Copyright VIKYNGO
# SPDX-License-Identifier: (Apache-2.0 AND CC-BY-4.0)
# Code is Apache-2.0 and docs are CC-BY-4.0


set -o nounset

# Make sure umask is sane
umask 022

# defaults
stack_branch=${STACK_BRANCH:="master"}
stack_web=${STACK_WEB:="v-i-k-y-n-g-o/web-app"}
stack_server=${STACK_SERVER:="v-i-k-y-n-g-o/server"}

# Check for uninitialized variables
NOUNSET=${NOUNSET:-}
if [[ -n "$NOUNSET" ]]; then
	set -o nounset
fi

git clone https://github.com/${stack_web}.git -b $stack_branch || true
git clone https://github.com/${stack_server}.git -b $stack_branch || true

# Kill background processes on exit
trap exit_trap EXIT
function exit_trap {
    exit $?
}
# Exit on any errors so that errors don't compound and kill if any services already started
trap err_trap ERR
function err_trap {
    local r=$?
    tmux kill-session bdb-dev
    set +o xtrace
    exit $?
}

echo -e "Finished stacking!"
set -o errexit