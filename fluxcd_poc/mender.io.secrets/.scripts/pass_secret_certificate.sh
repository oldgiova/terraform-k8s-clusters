#!/bin/bash
set -euo pipefail

# prepare output for terragrunt run_cmd command
SECRET_ENTRY=$1
DATA_ENTRY=$2

pass ${SECRET_ENTRY} | yq '.data["'${DATA_ENTRY}'"]' | base64 -d
