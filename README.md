# QA Plugin

This repository contains a collection of agents and skills designed to automate and assist with Quality Assurance tasks for the platform.

## Overview

The primary purpose of this plugin is to streamline QA workflows by providing tools to:

*   Generate Playwright test scripts.
*   Fetch test steps from Zephyr for Jira.
*   Execute tests against various environments.

## Project Structure

-   `agents/`: Contains definitions for agents that orchestrate various QA tasks.
-   `skills/`: Houses the underlying scripts and logic for each automated capability.
-   `config.json`: Configuration file for environments and credentials.

## Configuration

The `config.json` file is used to define the target environments and the credentials for accessing them.

### Environments

You can specify different environments (e.g., QA, Staging) with their corresponding URLs:

```json
"environments": [
  {
    "name": "QA",
    "url": "https://qa.example.com"
  },
  {
    "name": "Stage",
    "url": "https://stage.example.com"
  }
]
```

### Credentials

Define credentials for different user roles:

```json
"credentials": [
  {
    "name": "admin",
    "username": "qa@example.com",
    "password": "your_password_here"
  }
]
```

## Available Skills

*   **Generate Playwright Script**: Automates the creation of Playwright test scripts.
*   **Get Zephyr Test Steps**: Fetches test case steps directly from Zephyr in Jira.
*   **Run Test**: Executes automated tests against the configured environments.

## Usage

To use a skill, you would typically invoke the corresponding agent. The agent will then use the scripts in the `skills` directory to perform the requested action. For example, to run a test, you would use the "run-test" agent, which would then execute the test run logic.
