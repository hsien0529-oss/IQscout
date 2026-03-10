#!/bin/bash
# ============================================
#  VEX IQ Scout - Deploy to GitHub Pages
#  Double-click this file to upload index.html
# ============================================

cd "$(dirname "$0")"

# ---- Settings ----
REPO="hsien0529-oss/iqscout"
FILE="index.html"
BRANCH="main"

# Check for saved token
TOKEN_FILE="$HOME/.vex-scout-github-token"
if [ -f "$TOKEN_FILE" ]; then
  GITHUB_TOKEN=$(cat "$TOKEN_FILE")
else
  echo "============================================"
  echo "  First time setup: GitHub Token needed"
  echo "============================================"
  echo ""
  echo "Go to: https://github.com/settings/tokens"
  echo "Use your existing token or create a new one."
  echo ""
  printf "Paste your GitHub token here: "
  read -r GITHUB_TOKEN
  echo ""

  if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: No token provided. Exiting."
    echo ""
    echo "Press any key to close..."
    read -n 1
    exit 1
  fi

  echo "$GITHUB_TOKEN" > "$TOKEN_FILE"
  chmod 600 "$TOKEN_FILE"
  echo "Token saved!"
  echo ""
fi

echo "Uploading $FILE to github.com/$REPO ..."
echo ""

# Get current file SHA (needed for update)
SHA=$(curl -s \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO/contents/$FILE?ref=$BRANCH" \
  | python3 -c "import sys,json; print(json.load(sys.stdin).get('sha',''))" 2>/dev/null)

# Base64 encode the file
CONTENT=$(base64 -i "$FILE")

# Build JSON payload
if [ -n "$SHA" ]; then
  PAYLOAD=$(python3 -c "
import json, sys
print(json.dumps({
    'message': 'Update IQ scout tool',
    'content': sys.argv[1],
    'sha': sys.argv[2],
    'branch': sys.argv[3]
}))
" "$CONTENT" "$SHA" "$BRANCH")
else
  PAYLOAD=$(python3 -c "
import json, sys
print(json.dumps({
    'message': 'Add IQ scout tool',
    'content': sys.argv[1],
    'branch': sys.argv[2]
}))
" "$CONTENT" "$BRANCH")
fi

# Upload via GitHub API
RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X PUT \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO/contents/$FILE" \
  -d "$PAYLOAD")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
  echo "============================================"
  echo "  Upload successful!"
  echo "============================================"
  echo ""
  echo "  Your site will update in 1-2 minutes:"
  echo "  https://hsien0529-oss.github.io/iqscout/"
  echo ""
else
  echo "============================================"
  echo "  Upload failed (HTTP $HTTP_CODE)"
  echo "============================================"
  echo ""
  echo "$RESPONSE" | head -5
  echo ""
  echo "If token expired, delete the saved token:"
  echo "  rm $TOKEN_FILE"
  echo "Then run this script again."
  echo ""
fi

echo "Press any key to close..."
read -n 1
