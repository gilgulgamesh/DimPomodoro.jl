#!/bin/bash

read -p "You guys gotta install julia yourself, I cant do that for all of yall. If you have it then press Y/y" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    julia --project=. -e "using Pkg; Pkg.instantiate()"
fi


