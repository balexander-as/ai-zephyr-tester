---
description: Use this skill when the user wants to fetch, get, or retrieve test steps from Zephyr Scale for a specific test case. Trigger phrases include: "get test steps", "fetch test steps", "show test steps for AS-T123", "what are the steps for test", or any request to look up or display Zephyr test case steps. Requires a Test ID.
---

# Get Zephyr Test Steps

Fetches the test steps for a given Zephyr Scale test case ID, cleans the HTML formatting, and returns a structured list of steps. This is done by executing a platform-appropriate script.

## INPUT

- **Test ID**: The ID of the Zephyr test case (e.g., "AS-T123").

## STEPS

1.  **Detect OS**: Check whether the current platform is Windows or Unix/macOS.
    - On **Windows**: run `skills/get-zephyr-test-steps/get-steps.ps1` using PowerShell.
    - On **Unix/macOS**: run `skills/get-zephyr-test-steps/get-steps.sh` using Bash.

2.  **Execute the script**: Pass the Test ID as the first argument. The script calls the Zephyr Scale API, validates the response, and strips HTML tags from the step fields.

3.  **Return the output**: The script returns a JSON object with a `steps` array, where each step contains `description`, `testData`, and `expectedResult`.

## OUTPUT

A JSON object containing a list of test steps, where each step has:
- `description`: The step's description.
- `testData`: The step's test data.
- `expectedResult`: The step's expected result.
