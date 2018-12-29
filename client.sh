#!/bin/bash

# launch hunter_gather main.lua with love-11.2-x86_64 binary
export LOCALDIR="$(dirname "$(which "$0")")"
export LOVE2D_LAUNCHER="${LOCALDIR}/love2d/love-11.2-x86_64/love"

exec ${LOVE2D_LAUNCHER} ${LOCALDIR} 
