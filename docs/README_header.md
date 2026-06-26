# GitFlow with HCP Terraform using .tfvars

This repository demonstrates how to manage Terraform variable files across environments using a GitFlow branching strategy. It shows how to isolate per-environment configuration using tfvars files organized in a structured directory, and how to configure HCP Terraform workspaces to target one specific file per environment.

## What this demo demonstrates

- How to organize Terraform variable files by environment using a folder-per-environment pattern.
- How to map GitFlow branches (`dev`, `test`, `main`) to deployment environments (`dev`, `test`, `prod`).
- How to configure an HCP Terraform workspace to target one explicit tfvars file path.
- How variable values flow from a tfvars file through an input variable to an output, confirming the active environment.

## Features

- Three-branch GitFlow model with a controlled promotion path: `dev` → `test` → `main`.
- Environment-scoped tfvars directory structure under `environment/<env>/app.tfvars`.
- A validated `environment` input variable that only accepts `dev`, `test`, or `prod`.
- An `environment` output that confirms which environment is active at plan and apply time.
- GitHub Actions workflows that run on every branch push and PR, with tag creation scoped to merges into `main`.

## Demo Components

| Component | Description |
| --- | --- |
| `environment/dev/app.tfvars` | Variable values for the dev environment |
| `environment/test/app.tfvars` | Variable values for the test environment |
| `environment/prod/app.tfvars` | Variable values for the prod environment |
| `variables.tf` | Declares the `environment` input variable with allowed-value validation |
| `outputs.tf` | Exposes the `environment` output |
| `versions.tf` | Terraform version constraint |
| `.github/workflows/` | CI workflows for formatting, linting, docs, and tag release |

## How this demo works

1. Each HCP Terraform workspace targets one tfvars file, for example `environment/dev/app.tfvars`.
2. When a plan or apply runs, Terraform reads `environment = "dev"` from that file.
3. The value is validated against the allowed list (`dev`, `test`, `prod`).
4. The `environment` output renders the resolved value, confirming which environment is active.
5. To promote to the next stage, a pull request is raised from `dev` to `test`, or from `test` to `main`, and the corresponding workspace targets the appropriate tfvars file.

## Demo Value Proposition

This demo illustrates a simple, repeatable pattern for managing environment-specific configuration in Terraform without duplicating root module code. It shows how GitFlow and workspace variable file targeting combine to provide clear environment ownership, safe promotion gates, and predictable runtime behavior.

## How to Conduct the Demo

1. Show the `environment/` directory structure and explain the one-file-per-environment model.
2. Open the workspace settings in HCP Terraform and highlight the tfvars file path targeting `environment/dev/app.tfvars`.
3. Trigger a plan and show the output value confirming `environment = "dev"`.
4. Switch the workspace target to `environment/test/app.tfvars` and re-run to demonstrate the promotion pattern.
5. Walk through the branch model: changes start on `dev`, are promoted via PR to `test`, then to `main`.

## Expected Behavior

After a successful `terraform apply` with the dev workspace targeting `environment/dev/app.tfvars`:

```text
Outputs:

environment = "dev"
```

Each workspace produces the matching output value for its environment.

## HCP Terraform Workspace Configuration

Each environment requires one HCP Terraform workspace. The workspace must be configured with the following environment variables to target the correct tfvars file at plan and apply time.

### dev workspace

| Variable | Type | Value |
| --- | --- | --- |
| `TF_CLI_ARGS_plan` | Environment | `-var-file=environment/dev/app.tfvars` |
| `TF_CLI_ARGS_apply` | Environment | `-var-file=environment/dev/app.tfvars` |

### test workspace

| Variable | Type | Value |
| --- | --- | --- |
| `TF_CLI_ARGS_plan` | Environment | `-var-file=environment/test/app.tfvars` |
| `TF_CLI_ARGS_apply` | Environment | `-var-file=environment/test/app.tfvars` |

### prod workspace

| Variable | Type | Value |
| --- | --- | --- |
| `TF_CLI_ARGS_plan` | Environment | `-var-file=environment/prod/app.tfvars` |
| `TF_CLI_ARGS_apply` | Environment | `-var-file=environment/prod/app.tfvars` |

> Both `TF_CLI_ARGS_plan` and `TF_CLI_ARGS_apply` must be set to the same value. They cannot be combined into one variable because each is scoped to a specific Terraform subcommand, which prevents the flag from being injected into `init` or `validate` runs.

## Permissions

### Provider Permissions

No cloud provider is required for this demo. The Terraform configuration only reads a local variable and produces an output. No IAM roles or cloud credentials are needed.

## Authentications

### Provider Authentication

No provider authentication is required for this demo.
