#!/bin/bash

USER_POOL_ID=$1
CLIENT_ID=$2
SIGN_IN=false

# Optional flag
if [[ "$3" == "--signin" ]]; then
  SIGN_IN=true
fi

# Configuration
USERNAME="test@example.com"
PASSWORD="example123"

# Check required args
if [[ -z "$USER_POOL_ID" || -z "$CLIENT_ID" ]]; then
  echo "Usage: ./create_test_user.sh <USER_POOL_ID> <CLIENT_ID> [--signin]"
  exit 1
fi

echo "--- STARTING SETUP ---"
echo "Pool ID: $USER_POOL_ID"
echo "Client ID: $CLIENT_ID"
echo "Sign in after create: $SIGN_IN"

# 1. Create the user
echo "1. Creating user $USERNAME..."
aws cognito-idp admin-create-user \
  --user-pool-id "$USER_POOL_ID" \
  --username "$USERNAME" \
  --user-attributes Name=email,Value="$USERNAME" \
  --message-action SUPPRESS \
  > /dev/null 2>&1 || echo "   (User might already exist, continuing...)"

# 2. Set permanent password
echo "2. Setting permanent password..."
aws cognito-idp admin-set-user-password \
  --user-pool-id "$USER_POOL_ID" \
  --username "$USERNAME" \
  --password "$PASSWORD" \
  --permanent

# 3. Optional sign-in
if [[ "$SIGN_IN" == true ]]; then
  echo "3. Verifying login..."
  AUTH_RESULT=$(aws cognito-idp initiate-auth \
    --client-id "$CLIENT_ID" \
    --auth-flow USER_PASSWORD_AUTH \
    --auth-parameters USERNAME="$USERNAME",PASSWORD="$PASSWORD")

  if echo "$AUTH_RESULT" | grep -q "AccessToken"; then
    echo "SUCCESS: User created and logged in successfully!"
  else
    echo "FAILED: Could not log in."
    echo "$AUTH_RESULT"
  fi
else
  echo "3. Skipping sign-in (use --signin to enable)"
fi
