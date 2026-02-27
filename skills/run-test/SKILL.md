---
description: Use this skill when the user wants to run, execute, or launch a Zephyr Scale test case in a browser. Trigger phrases include: "run test", "execute test", "run AS-T123", "run the test", "test AS-T123", or any request to automate or validate a Zephyr test. Requires a Test ID, an Environment name (e.g., QA, Stage, Dev5), and a Credentials name.
---

# Run Test Skill

This skill orchestrates the process of running a Zephyr Scale test case by fetching the test steps and executing them directly using Playwright MCP tools — no intermediate script is generated.

## INPUT

The following input parameters are required:
- **Test ID**: The ID of the Zephyr test to run (e.g., "AS-T123").
- **Environment**: The name of the test environment to use (e.g., QA, Stage, Dev5).
- **Credentials**: The name of the credentials to use (e.g., admin).

## STEPS

1.  **Load Configuration**: Read the `config.json` file to find the URL for the specified environment and the username/password for the specified credentials.

2.  **Get Test Steps**: Use the `Agent` tool to spawn the `ai-zephyr-tester:get-zephyr-test-steps` subagent with the Test ID as input. **Do NOT use Zephyr MCP tools for this step** — they do not have a test steps endpoint and will return wrong data. Wait for the subagent to return the cleaned JSON `steps` array.

3.  **Execute Steps Directly with Playwright MCP**: For each step in the test case, interpret the `description`, `testData`, and `expectedResult` fields and invoke the appropriate Playwright MCP tools directly (e.g., `browser_navigate`, `browser_click`, `browser_fill_form`, `browser_type`, `browser_snapshot`, etc.). Use the environment URL and credentials loaded in step 1. After each step, verify the result against `expectedResult` and note any failures.

4.  **Output Results**: Report the overall pass/fail outcome and a per-step summary to the user. Include any screenshots or snapshots captured during the run.

5.  **Confirm Execution Update**: Ask the user if they want to update the Zephyr Scale test execution with the pass/fail result. Do not proceed with the update without explicit user confirmation.
