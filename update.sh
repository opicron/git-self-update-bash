#!/bin/bash
                                               # Here I remark changes
###
SCRIPT="$(readlink -f "$0")"
SCRIPTFILE="$(basename "$SCRIPT")"             # get name of the file (not full path)
SCRIPTPATH="$(dirname "$SCRIPT")"
SCRIPTNAME="$0"
ARGS=( "$@" )                                  # fixed to make array of args (see below)

self_update() {
    cd "$SCRIPTPATH"
    git fetch --quiet

                                               # in the next line
                                               # 1. added double-quotes (see below)
                                               # 2. removed grep expression so
                                               # git-diff will check only script
                                               # file

    git diff --quiet --exit-code "origin/main" "$SCRIPTFILE"
    [ $? -eq 1 ] && {
        #echo "Found a new version of me, updating myself..."
        if [ -n "$(git status --porcelain)" ];  # opposite is -z
        then 
            git stash push -m 'local changes stashed before self update' --quiet
        fi
        git pull --force --quiet
        git checkout main --quiet
        git pull --force --quiet
        #echo "Running the new version..."
        cd -                                   # return to original working dir
        #exec "$SCRIPTNAME" "${ARGS[@]}"

        # Now exit this old instance
        exit 1
    }
    #echo "Already the latest version."
}
self_update
echo "some code2"
