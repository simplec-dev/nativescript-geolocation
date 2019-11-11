#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR=${CURRENT_DIR//\/cygdrive\/c/c\:}
SOURCE_DIR="$CURRENT_DIR/../src"
TO_SOURCE_DIR="$CURRENT_DIR/src"
PACK_DIR="$CURRENT_DIR/package"
ROOT_DIR="$CURRENT_DIR/.."
PUBLISH=--publish

install(){
    cd $CURRENT_DIR
    npm i
}

pack() {

    echo 'Clearing /src and /package...'
    node_modules/.bin/rimraf "$TO_SOURCE_DIR"
    node_modules/.bin/rimraf "$PACK_DIR"
    mkdir "$TO_SOURCE_DIR"

    # copy src
    echo 'Copying src...'
    node_modules/.bin/ncp "$SOURCE_DIR" "$TO_SOURCE_DIR"

    # copy README & LICENSE to src
    echo 'Copying README and LICENSE to /src...'
    node_modules/.bin/ncp "$ROOT_DIR"/LICENSE "$TO_SOURCE_DIR"/LICENSE
    node_modules/.bin/ncp "$ROOT_DIR"/README.md "$TO_SOURCE_DIR"/README.md

    # compile package and copy files required by npm
    echo 'Building /src...'
    cd "$TO_SOURCE_DIR"
    npm i
    node_modules/.bin/tsc

    echo 'Building plugin .aar...'
    tns plugin build
    cd ..

    echo 'Creating package...'
    # create package dir
    mkdir "$PACK_DIR"

    echo 'Creating package....'
    # create the package
    cd "$PACK_DIR"
    echo 'Creating package.....'
    npm pack "$TO_SOURCE_DIR"

}

install && pack