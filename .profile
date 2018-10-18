#!/usr/bin/env bash

# Install modules & setup Postgres backend
terraform init -backend-config="conn_str=$DATABASE_URL"
