#!/usr/bin/env bash

# Install modules & setup Postgres backend
bin/terraform init -backend-config="conn_str=$DATABASE_URL"
