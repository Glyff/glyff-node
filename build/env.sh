#!/bin/sh

set -e

if [ ! -f "build/env.sh" ]; then
    echo "$0 must be run from the root of the repository."
    exit 2
fi

# Create fake Go workspace if it doesn't exist yet.
workspace="$PWD/build/_workspace"
root="$PWD"
glydir="$workspace/src/github.com/glyff"
if [ ! -L "$glydir/glyff-node" ]; then
    mkdir -p "$glydir"
    cd "$glydir"
    ln -s ../../../../../. glyff-node
    cd "$root"
fi

# Set up the environment to use the workspace.
GOPATH="$workspace"
export GOPATH

# Run the command inside the workspace.
cd "$glydir/glyff-node"
PWD="$glydir/glyff-node"

# Launch the arguments with the configured environment.
exec "$@"
