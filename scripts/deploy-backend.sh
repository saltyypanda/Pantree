#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Build lambdas
echo "--- BUILDING LAMBDAS ---"
"$SCRIPT_DIR/build_lambdas.sh"
echo "Done."

# Run terraform
echo "--- STARTING TERRAFORM ---"
cd "$ROOT_DIR/infra"
terraform init
terraform apply -auto-approve
echo "Done."

# Write output to .env
echo "--- WRITING ENV ---"
"$SCRIPT_DIR/write_env.sh"
echo "Done."

# Create test user
echo "--- CREATING TEST USER ---"
"$SCRIPT_DIR/create_test_user.sh" \
  "$(terraform output -raw user_pool_id)" \
  "$(terraform output -raw user_pool_client_id)"
echo "Done."

echo "--- BACKEND DEPLOYED ---"