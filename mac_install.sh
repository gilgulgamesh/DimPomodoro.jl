#!/bin/bash
brew install julia

julia --project=. -e "using Pkg; Pkg.instantiate()"

