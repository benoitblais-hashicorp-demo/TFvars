# AGENTS.md for TFvars GitFlow Demo

This file provides instructions for AI coding agents working on this repository.

## Project Purpose

This repository demonstrates a feature-branch workflow with Terraform tfvars files.
The focus is branch strategy, variable file organization, and environment-targeted Terraform runs triggered manually via workflow dispatch.

## Source of Truth

- This AGENTS.md file is the source of truth for agent behavior in this repository.
- Keep the implementation simple and centered on tfvars workflow patterns.

## Branch Model

Use this two-branch model:

- main: the single long-lived branch. Always production-ready.
- feature/*: short-lived branches for individual changes. Created from main and merged back into main via pull request.

Promotion direction:

- feature/* -> main (via pull request)

Do not create long-lived environment branches. Merging to main does not trigger a Terraform run.

## Terraform Run Trigger

Terraform runs are triggered manually via the `Terraform Dispatch` workflow (`workflow_dispatch`).
The workflow presents a dropdown to select the target environment (dev, test, or prod).
The selected environment maps directly to the tfvars file at `environment/{env}/app.tfvars`.
Runs are never triggered automatically on push or merge.

## Authentication

The dispatch workflow authenticates to HCP Terraform using a user or team API token stored as a GitHub secret named `TFE_TOKEN`.
Do not use Vault or any other secrets backend for this repository.

## tfvars Directory Structure

Store tfvars in an environment folder with one subfolder per environment.

Required pattern:

```text
environment/
  dev/
    *.tfvars
  test/
    *.tfvars
  prod/
    *.tfvars
```

Notes:

- Each environment subfolder can contain one or more tfvars files.
- Keep naming explicit and environment-scoped.
- Avoid duplicating values across files when a shared variable definition can be used.

## Workspace Targeting Rules

- Workspace configuration must target one explicit tfvars file path.
- Do not use ambiguous wildcards for runtime variable selection.
- When making changes, preserve the selected environment path unless the user asks to switch it.

Example target path shape:

- environment/dev/app.tfvars

## Agent Change Policy

- Keep changes minimal and aligned to the requested branch and environment.
- Do not modify files for other environments unless requested.
- Do not refactor unrelated Terraform code during tfvars workflow updates.

## Validation Expectations

- Prefer producing Terraform that is already style-compliant.
- If local execution is available, run fmt and validate before finalizing changes.
- If local execution is not available, clearly state that validation was deferred to CI.

## Security and Secrets

- Never commit secrets in tfvars files.
- Commit only non-sensitive example values when needed for demonstration.
- Use sensitive workspace variables or secret backends for real credentials.
- Mark sensitive Terraform inputs with sensitive = true where applicable.

## Naming Conventions

- Use lowercase snake_case for variable names.
- Use clear environment labels in file names when helpful.
- Keep branch names and environment folder names consistent.

## Terraform File Conventions

The root module uses these canonical files:

- versions.tf: Terraform version constraint and required providers.
- variables.tf: all input variables with type and description.
- outputs.tf: all outputs in alphabetical order.
- main.tf: all resource definitions.

The `environment` variable is the primary input variable. Its value is always sourced from the environment-scoped tfvars file targeted by the workspace. It must be validated against the allowed values: dev, test, prod.

The `random_integer` resource in main.tf demonstrates a generic resource pattern. Its range is controlled by `random_min` and `random_max` input variables, both defaulting to 1 and 100 respectively.

## Out of Scope

- Do not introduce unrelated architecture patterns or platform migrations.
- Do not add complex tooling unless explicitly requested.
