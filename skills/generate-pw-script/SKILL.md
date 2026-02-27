---
description: Use this skill when the user wants to generate a Playwright test script from a Zephyr Scale test case. Trigger phrases include: "generate script", "create playwright script", "generate playwright script for AS-T123", "make a script for test", or any request to convert Zephyr test steps into automation code. Requires a Test ID.
---

# Generate Playwright Script

This skill takes a Zephyr Scale test case ID, fetches the test steps using the `get-zephyr-test-steps` skill, and generates a complete Playwright test script based on those steps.

## INPUT

- **Test ID**: The ID of the Zephyr test case (e.g., "AS-T123").

## STEPS

1.  **Receive Test ID**: Accept the Test ID as input.

2.  **Fetch Test Steps**: Call the `get-zephyr-test-steps` skill with the Test ID to retrieve the cleaned test steps as a JSON object with a `steps` array.

3.  **Generate Script**: For each step in the JSON output:
    - Use `description` to create a comment in the script.
    - Use `testData` and `expectedResult` to generate Playwright actions and assertions.
    - Use variables for selectors to keep the script maintainable.

4.  **Structure the script** as a `module.exports` function accepting `(page, env)` parameters, with navigation and login at the top followed by the generated test steps.

5.  **Return the script** as a complete, ready-to-run string.

## OUTPUT

A string containing the generated Playwright script.
