#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Test ID not provided."
    exit 1
fi

TEST_ID=$1

if ! [[ "$TEST_ID" =~ ^.+-T[0-9]+$ ]]; then
    echo $TEST_ID
    echo "Error: Invalid Test ID format. Expected format: PROJECT-T123"
    exit 1
fi

if [ -z "$ZEPHYR_API_TOKEN" ]; then
    echo "Error: ZEPHYR_API_TOKEN environment variable not set."
    exit 1
fi

URL="https://api.zephyrscale.smartbear.com/v2/testcases/$TEST_ID/teststeps"

response=$(curl -s -w "%{http_code}" -H "Authorization: Bearer $ZEPHYR_API_TOKEN" "$URL")
http_status=${response: -3}
body=${response:0:${#response}-3}

if [ "$http_status" -ne 200 ]; then
    echo "Error fetching test steps. Status: $http_status, Body: $body"
    exit 1
fi

echo "$body" | python3 -c '
import json
import sys
import re

try:
    data = json.load(sys.stdin)
    cleaned_steps = []
    for step in data.get("values", []):
        inline = step.get("inline", {})
        cleaned_step = {
            "description": re.sub("<[^>]+>", "", inline.get("description", "") or ""),
            "testData": re.sub("<[^>]+>", "", inline.get("testData", "") or ""),
            "expectedResult": re.sub("<[^>]+>", "", inline.get("expectedResult", "") or "")
        }
        cleaned_steps.append(cleaned_step)
    
    print(json.dumps({"steps": cleaned_steps}, indent=4))

except json.JSONDecodeError:
    sys.exit(1)
'
