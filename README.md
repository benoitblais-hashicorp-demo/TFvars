<!-- BEGIN_TF_DOCS -->
# Feature Branch Workflow with HCP Terraform using .tfvars

This repository demonstrates how to manage Terraform variable files across environments using a feature-branch workflow. It shows how to isolate per-environment configuration using tfvars files organized in a structured directory, and how to trigger HCP Terraform runs manually against a selected environment workspace.

## What this demo demonstrates

- How to organize Terraform variable files by environment using a folder-per-environment pattern.
- How to use a feature-branch model (`feature/*` → `main`) to manage infrastructure code changes.
- How to trigger an HCP Terraform run manually via `workflow_dispatch`, selecting the target environment at dispatch time.
- How variable values flow from a tfvars file through an input variable to an output, confirming the active environment.

## Features

- Feature-branch model: all changes are developed on `feature/*` branches and merged into `main` via pull request.
- Merging to `main` never triggers a Terraform run automatically.
- Environment-scoped tfvars directory structure under `environment/<env>/app.tfvars`.
- A validated `environment` input variable that only accepts `dev`, `test`, or `prod`.
- An `environment` output that confirms which environment is active at plan and apply time.
- A `Terraform Dispatch` workflow that triggers an HCP Terraform apply run against the selected environment workspace.
- GitHub Actions workflows for formatting, linting, docs, and tag release on every branch push and PR.

## Demo Components

| Component | Description |
| --- | --- |
| `environment/dev/app.tfvars` | Variable values for the dev environment |
| `environment/test/app.tfvars` | Variable values for the test environment |
| `environment/prod/app.tfvars` | Variable values for the prod environment |
| `variables.tf` | Declares the `environment` input variable with allowed-value validation |
| `outputs.tf` | Exposes the `environment` output |
| `versions.tf` | Terraform version constraint |
| `.github/workflows/terraform-dispatch.yml` | Manual dispatch workflow for triggering HCP Terraform runs per environment |
| `.github/workflows/` | CI workflows for formatting, linting, docs, and tag release |

## How this demo works

1. Changes are developed on a `feature/*` branch and merged into `main` via pull request.
2. Merging to `main` does not trigger any Terraform run.
3. To trigger a run, the `Terraform Dispatch` workflow is started manually from the GitHub Actions tab.
4. The workflow presents a dropdown to select the target environment (`dev`, `test`, or `prod`).
5. The selected environment maps to an HCP Terraform workspace (e.g. `TFvars-dev`) and the corresponding tfvars file (`environment/dev/app.tfvars`).
6. The workflow uploads the configuration, creates a run in HCP Terraform, and writes the run summary, plan output, and cost estimation to the job summary.

## Demo Value Proposition

This demo illustrates a simple, repeatable pattern for managing environment-specific configuration in Terraform without duplicating root module code. It shows how a feature-branch workflow and manual dispatch combine to provide clear environment ownership, controlled run triggers, and predictable runtime behavior.

## How to Conduct the Demo

1. Show the `environment/` directory structure and explain the one-file-per-environment model.
2. Open the GitHub Actions tab and run the `Terraform Dispatch` workflow, selecting `dev` from the environment dropdown.
3. Show the job summary: run status, plan output (add/change/destroy counts), workspace link, and cost estimation.
4. Repeat with `test` or `prod` to demonstrate environment isolation.
5. Walk through the branch model: a change is made on a `feature/*` branch, a PR is raised to `main`, and the dispatch workflow is used to apply it to the desired environment.

## Expected Behavior

After the `Terraform Dispatch` workflow runs successfully for the `dev` environment:

```text
Outputs:

environment = "dev"
```

Each workspace produces the matching output value for its environment.

## HCP Terraform Workspace Configuration

Each environment requires one HCP Terraform workspace named `<repository-name>-<environment>`:

| Environment | Workspace name |
| --- | --- |
| dev | `TFvars-dev` |
| test | `TFvars-test` |
| prod | `TFvars-prod` |

Each workspace must have the following environment variables set to target the correct tfvars file at plan and apply time:

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

### HCP Terraform Authentication

The `Terraform Dispatch` workflow authenticates to HCP Terraform using a user or team API token stored as a GitHub secret named `TFE_TOKEN`.

| Secret | Description |
| --- | --- |
| `TFE_TOKEN` | HCP Terraform user or team API token with permission to manage runs in the target workspaces |

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.9)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

## Modules

No modules.

## Required Inputs

The following input variables are required:

### <a name="input_environment"></a> [environment](#input\_environment)

Description: The target deployment environment. Value is sourced from the environment-scoped tfvars file.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_random_max"></a> [random\_max](#input\_random\_max)

Description: Maximum value for the random integer.

Type: `number`

Default: `100`

### <a name="input_random_min"></a> [random\_min](#input\_random\_min)

Description: Minimum value for the random integer.

Type: `number`

Default: `1`

## Resources

The following resources are used by this module:

- [random_integer.example](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)

## Outputs

The following outputs are exported:

### <a name="output_environment"></a> [environment](#output\_environment)

Description: The active deployment environment resolved from the workspace tfvars file.

### <a name="output_random_integer"></a> [random\_integer](#output\_random\_integer)

Description: A random integer generated within the configured min/max range.

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->