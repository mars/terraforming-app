#!/usr/bin/env bash

# Install modules & setup Postgres backend
terraform init -backend-config="conn_str=$DATABASE_URL" &> terraform_init_output.log

# When init fails, output the error and exit failure.
if [ ! "$?" -eq "0" ]
then
  cat terraform_init_output.log
  exit 1
fi

# Ensure the workspace exists
TERRAFORM_WORKSPACE_NAME="${TERRAFORM_WORKSPACE_NAME:-default}"
terraform workspace new $TERRAFORM_WORKSPACE_NAME
