---
description: Use this skill when the user wants to run, execute, or launch a Zephyr Scale test case in a browser. Trigger phrases include: "run test", "execute test", "run AS-T123", "run the test", "test AS-T123", or any request to automate or validate a Zephyr test. Requires a Test ID, an Environment name (e.g., QA, Stage, Dev5), and a Credentials name.
---

# Run Test Skill

This skill runs a Zephyr Scale test case interactively in three phases. After each phase, pause and ask the user if they want to proceed before continuing.

## INPUT

The following input parameters are required:
- **Test ID**: The ID of the Zephyr test to run (e.g., "AS-T123").
- **Environment**: The name of the test environment to use (e.g., QA, Stage, Dev5).
- **Credentials**: The name of the credentials to use (e.g., admin).

---

## PHASE 1 — Fetch Test Steps

1. Read `config.json` to resolve the environment URL and credentials (username/password).
2. Run the get-steps script directly via Bash — **do not use the `ai-zephyr-tester:get-zephyr-test-steps` subagent** (it can hallucinate steps) and **do not use Zephyr MCP tools** (they lack a test steps endpoint):
   ```
   powershell -File "C:/Users/BrandonAlexander/source/AbsenceSoftQA-plugin/skills/get-zephyr-test-steps/get-steps.ps1" -TestID "<TestID>"
   ```
   The script reads `ZEPHYR_API_TOKEN` from the environment (already set). Its output may contain HTML entities (`&gt;`, `&nbsp;`, etc.) — decode them before displaying.
3. Display the returned steps to the user as a numbered list showing each step's description, test data, and expected result.
4. **Ask the user: "Ready to generate the execution plan? (yes/no)"** — do not proceed to Phase 2 until confirmed.

---

## PHASE 2 — Generate Execution Plan

Based on the steps from Phase 1, produce a structured execution plan. For each step, determine:
- Which **Playwright MCP tool(s)** will be called (e.g., `browser_navigate`, `browser_click`, `browser_fill_form`, `browser_type`, `browser_snapshot`, `browser_wait_for`, etc.)
- The specific **arguments** you intend to pass (selector, URL, text, etc.)
- Whether a **screenshot** will be taken after the step (take screenshots after navigation steps, key interactions, and any step whose expected result is a visual state)

Present the plan as a numbered table or list in this format:

```
Step N: <description>
  Tool(s): browser_click(ref=...) | browser_snapshot()
  Screenshot: yes / no
  Verifies: <expectedResult>
```

If any step is ambiguous or requires runtime information (e.g., a dynamic ref), note it as "TBD — resolved at runtime".

**Ask the user: "Does this plan look correct? Shall I execute it? (yes/no/edit)"** — do not proceed to Phase 3 until confirmed.

---

## PHASE 3 — Execute & Summarize

Execute each step in the plan using Playwright MCP tools. For each step:
- Call the planned tool(s)
- If a screenshot was marked, call `browser_take_screenshot` and include the image
- Compare the actual page state to the `expectedResult` and mark the step **PASS** or **FAIL**

After all steps are complete, output a results summary:

```
Test: <Test ID> | Environment: <env> | Overall: PASS / FAIL

| # | Description                  | Result | Notes         |
|---|------------------------------|--------|---------------|
| 1 | Navigate to Leave Admin page | PASS   |               |
| 2 | Locate Vacation leave type   | FAIL   | Row not found |
```

Then **ask the user: "Would you like to update the Zephyr test execution with this result? (yes/no)"** — do not update Zephyr without explicit confirmation.
