# !/bin/bash

set -e

USAGE="Permanently delete a submodule from a git repository.

Args:
    -s      Submodule path (required)
    -h      Print this help message

Examples:
    $0 -s code/components/third-party/amazon-kinesis
    $0 -h
"

# Get the submodule path
while getopts ':s:h' c
do
  case $c in
    s) SUBMODULE_PATH="$OPTARG" ;;
    h) echo "$USAGE" && exit 0 ;;
    *) echo "$USAGE" && exit 1
  esac
done

# Make sure we have a submodule path
if [ -z "$SUBMODULE_PATH" ]; then
    echo "Please provide a submodule path using the -s flag"
    echo "$USAGE"
    exit 1
fi

set -u

# Warning about deleting submodule
echo ""
echo "WARNING: You are about to permanently delete the submodule '$SUBMODULE_PATH'. You will need to re-add the submodule if you wish to use it in the future."
echo ""

# Ask for user confirmation before proceeding (default: don't proceed)
read -r -p "Would you like to proceed? [y/N]: " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ ! $response =~ ^(yes|y) ]]; then
    echo "Exiting"
    exit 1
fi

GIT_REPO_ROOT=($(git rev-parse --show-toplevel))
echo "Git repository root: $GIT_REPO_ROOT"

echo "----------------------------------------"
echo "Deleting submodule directory.."
echo "----------------------------------------"
rm -rf $SUBMODULE_PATH

echo "----------------------------------------"
echo "Deinitializing submodule.."
echo "----------------------------------------"
git submodule deinit $SUBMODULE_PATH

echo "----------------------------------------"
echo "Deleting submodule from .gitmodules.."
echo "----------------------------------------"
git rm $SUBMODULE_PATH -f

echo "----------------------------------------"
echo "Deleting submodule from .git/modules.."
echo "----------------------------------------"
rm -rf $GIT_REPO_ROOT/.git/modules/$SUBMODULE_PATH

echo ""
echo "Submodule '$SUBMODULE_PATH' deleted"