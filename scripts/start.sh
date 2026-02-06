#!/bin/bash

# Run terraform
cd ./infra
echo "--- STARTING TERRAFORM ---"
terraform init
terraform apply -auto-approve

cd ../

# Write output to .env
echo "--- WRITING ENV ---"
./scripts/write_env.sh

# Create test user
echo "--- CREATING TEST USER ---"
./scripts/create_test_user.sh $(terraform output -raw user_pool_id) $(terraform output -raw user_pool_client_id)

# Initialize database
echo "--- INITIALIZING DATABASE ---"
py ./scripts/init_db.py