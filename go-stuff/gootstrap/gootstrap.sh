#!/bin/bash
#
# do the things i like to do every time i set up a small go project
echo "gootstrapping a go project in ${PWD}"

# collect some paths we'll use throughout the script
SCRIPT_DIR_PATH="$(dirname $0)"
FULL_DIR_PATH="${PWD}"
SHORT_DIR_NAME="$(basename $FULL_DIR_PATH)"

# create the main package and function
mkdir "$FULL_DIR_PATH/cmd"
mkdir "$FULL_DIR_PATH/cmd/$SHORT_DIR_NAME"
cp "$SCRIPT_DIR_PATH/main.template.go" "$FULL_DIR_PATH/cmd/$SHORT_DIR_NAME/main.go"

# make the directory for internal packages
mkdir "$FULL_DIR_PATH/internal"

# set up a makefile for common tasks
cp "$SCRIPT_DIR_PATH/Makefile.template" "$FULL_DIR_PATH/Makefile"
gsed -E -i "s/<PACKAGE_NAME>/$SHORT_DIR_NAME/g" "$FULL_DIR_PATH/Makefile"

# setup the go module and and build the app
make "$FULL_DIR_PATH/Makefile" mod-init
make "$FULL_DIR_PATH/Makefile" run

# commit the changes
git --work-tree=$FULL_DIR_PATH --git-dir=$FULL_DIR_PATH/.git branch
git add --all
git commit -m $FUL"bootstrap the go app with gootstrap.sh"

echo "if you don't see 'hello world' above this somewhere then something went wrong, otherwise, all done!"
