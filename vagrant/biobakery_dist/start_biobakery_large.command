#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"
VAGRANT_VB_MEMORY=3072 vagrant up
