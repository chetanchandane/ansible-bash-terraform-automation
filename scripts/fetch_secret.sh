#!/bin/bash

# ---- CONFIG ----
SECRET_KEY=$1                          # e.g., "db-creds"
API_URL="http://127.0.0.1:5050/get-secret"
API_TOKEN="supersecrettoken123"        # matches your Flask VALID_TOKENS

# ---- REQUEST ----
response=$(curl -s -H "X-Token: $API_TOKEN" "$API_URL?key=$SECRET_KEY")

# ---- CHECK IF SECRET EXISTS ----
if echo "$response" | grep -q "error"; then
  echo "Failed to fetch secret: $response"
  exit 1
fi

# ---- SAVE SECRET ----
mkdir -p ~/vault
echo "$response" > ~/vault/$SECRET_KEY.json
echo "Secret saved to ~/vault/$SECRET_KEY.json"
