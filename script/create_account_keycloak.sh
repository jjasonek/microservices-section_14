#!/bin/bash

KEYCLOAK_URL="http://localhost:7080/realms/master/protocol/openid-connect/token"
CLIENT_ID="eazybank-callcenter-cc"
CLIENT_SECRET="7tPUlOgJvGHO8Z9yBpowxkNAFpzZ10Dm"
API_URL_CREATE_ACCOUNT="http://172.21.16.1:8072/eazybank/accounts/api/create"
API_URL_CREATE_CARD="http://172.21.16.1:8072/eazybank/cards/api/create?mobileNumber=4354437687"
API_URL_CREATE_LOAN="http://172.21.16.1:8072/eazybank/loans/api/create?mobileNumber=4354437687"

# Step 1: Get the access token
ACCESS_TOKEN=$(curl -s -X POST "$KEYCLOAK_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=$CLIENT_ID" \
  -d "scope=openid email profile" \
  -d "client_secret=$CLIENT_SECRET" | jq -r '.access_token')

# Debugging output
echo "Token: $ACCESS_TOKEN"

# Step 2: Make authenticated API request to create an account
curl -X POST "$API_URL_CREATE_ACCOUNT" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Madan Reddy",
    "email": "tutor@eazybytes",
    "mobileNumber": "4354437687"
  }'

  # Step 3: Make authenticated API request to create a card
  curl -X POST "$API_URL_CREATE_CARD" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H "Content-Type: application/json"

  # Step 4: Make authenticated API request to create a loan
  curl -X POST "$API_URL_CREATE_LOAN" \
      -H "Authorization: Bearer $ACCESS_TOKEN" \
      -H "Content-Type: application/json"
