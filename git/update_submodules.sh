# !/bin/bash

USAGE="""Recursively update the submodules of a Git repository

    Usage:
        $0
        $0 -h
"""

# Display the usage if any arguments are provided
if [ $# -ne 0 ]; then
    echo "$USAGE"
    exit 1
fi

# Exit on an error or undefined variable
set -eu

# Must be done from repo root
GIT_REPO_ROOT=($(git rev-parse --show-toplevel))
cd $GIT_REPO_ROOT

# Add all the submodules of the Git repository (current directory)
SUBMODULE_ARRAY=($(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'))

# Force-remove all submodule directories
for submodule in "${SUBMODULE_ARRAY[@]}"; do
    echo "Deleting directory $submodule"
    rm -rf $submodule
done

# Sync with the latest submodules, update recursively
(git submodule sync --recursive && git submodule update --init --recursive)

# Go back to previous directory
cd -