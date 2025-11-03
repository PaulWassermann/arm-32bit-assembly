#!/bin/bash

set -e

DEBUG_OPTS=""
PROGRAM=""

INFO_PREFIX="[+]"
ERROR_PREFIX="[x]"

log_info() {
    echo -e "${INFO_PREFIX} $1"
}

log_error() {
    echo -e "${ERROR_PREFIX} $1" >&2
}

print_usage() {
    echo "Usage: $0 -p <program-number> [-d] [-h]"
    echo "   -p <program-number>  Program number to build (mandatory)"
    echo "   -d                   Enable debug symbols for the assembler"
    echo "   -h                   Show this help message"
    exit "$1"
}

while getopts "p:dvh" flags
do 
    case "${flags}" in
        p)PROGRAM="$OPTARG";;
        d)DEBUG_OPTS="-g";;
        h)print_usage 0;;
        *)print_usage 1;;
    esac
done

if [ -z "$PROGRAM" ]; then
    log_error "$ERROR_PREFIX Missing -p argument (program number to build)"
    print_usage 1
fi

FOLDER=$(find -type d -name "${PROGRAM}_*" -print -quit)

if [ -z "$FOLDER" ]; then
    log_error "Did not find a program with number $PROGRAM"
    exit 1
else 
    log_info "Found program folder: $FOLDER"
    cd "$FOLDER"
fi

mkdir -p obj bin

SRC="main.s"
OBJ="obj/main.o"
OUT="bin/main"

if [[ ! -f "$SRC" ]]; then
    log_error "Source file '$SRC' not found in $FOLDER"
    exit 1
fi

log_info "Assembling $SRC..."
arm-linux-gnueabihf-as $DEBUG_OPTS -o "$OBJ" "$SRC"

log_info "Linking $OBJ..."
arm-linux-gnueabihf-ld -o "$OUT" "$OBJ"

log_info "Build successful: $OUT"

cd - > /dev/null