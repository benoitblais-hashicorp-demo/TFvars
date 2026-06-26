# GitFlow with tfvars Specification

## 1. Purpose

Define implementation requirements for a Terraform repository that demonstrates a feature-branch workflow using environment-scoped tfvars files.

This specification is the source of truth for branch behavior, tfvars organization, workspace targeting, Terraform run dispatch, and acceptance criteria.

## 2. Scope

### 2.1 In Scope

- Feature-branch workflow with a single long-lived main branch.
- Manual Terraform run dispatch targeting a selected environment.
- Environment-specific tfvars organization.
- Workspace configuration that targets one explicit tfvars file.
- Documentation and process rules that keep branch promotion predictable.

### 2.2 Out of Scope

- Platform-specific architecture decisions unrelated to tfvars workflow.
- Advanced deployment orchestration outside standard Terraform workflows.
- Secret management product comparisons or migration tracks.

## 3. Branch Model and Run Trigger

The repository uses a single long-lived branch:

- main: always production-ready.

All changes are developed on short-lived feature branches (`feature/*`) and merged into main via pull request.

Merging to main does **not** trigger a Terraform run.

Terraform runs are triggered manually via the `Terraform Dispatch` workflow (`workflow_dispatch`). The workflow presents a dropdown to select the target environment (dev, test, or prod). The selected environment maps directly to `environment/{env}/app.tfvars`.

Direct commits to main are not allowed.

## 4. Environment tfvars Structure

All tfvars files must live under environment with one subfolder per environment.

Required directory pattern:

```text
environment/
  dev/
    *.tfvars
  test/
    *.tfvars
  prod/
    *.tfvars
```

Requirements:

- Keep values isolated by environment.
- Use explicit file names that describe intent.
- Keep file naming and folder naming consistent with branch intent.

## 5. Workspace Targeting Requirements

Each workspace configuration must target exactly one tfvars file path.

Example path shape:

- environment/dev/app.tfvars

Rules:

- Do not use wildcards for tfvars runtime selection.
- Do not switch target path in unrelated pull requests.
- Changes to workspace-targeted tfvars must be documented in the pull request.

## 6. Repository Conventions

Root Terraform module uses these files:

- versions.tf: Terraform version constraint and required providers.
- variables.tf: all input variables with type and description.
- outputs.tf: all outputs in alphabetical order.
- main.tf: all resource definitions.

Documentation files:

- docs/CONTRIBUTING.md
- docs/SPECIFICATION.md
- AGENTS.md

## 7. Functional Requirements

### FR-1 Feature Branch Workflow

All changes are made on a `feature/*` branch and merged into main via pull request. No long-lived environment branches exist.

### FR-2 Environment Isolation

Each environment has its own tfvars subfolder and no cross-environment leakage.

### FR-2b Manual Run Dispatch

Terraform runs are triggered exclusively via `workflow_dispatch`. The selected environment input determines the tfvars file used at runtime. Runs are never triggered automatically on push or merge.

### FR-3 Deterministic Workspace Input

Workspace execution always resolves to one explicit tfvars file path.

### FR-4 Controlled Change Scope

Pull requests should modify only the environment and branch relevant to the stated change.

### FR-5 Environment Variable and Output

The root module defines an `environment` input variable sourced from the active tfvars file. The value is validated against allowed values (dev, test, prod) and exposed via an `environment` output. This output confirms which environment the workspace is targeting at plan and apply time.

### FR-6 Random Integer Resource

The root module includes a `random_integer` resource defined in `main.tf` to demonstrate a basic resource pattern. The range is controlled by `random_min` and `random_max` input variables. The generated value is exposed via a `random_integer` output.

## 8. Security Requirements

- Never commit secrets in tfvars files.
- The HCP Terraform API token must be stored as a GitHub secret named `TFE_TOKEN`. Do not use Vault or any other secrets backend for this repository.
- Mark sensitive Terraform inputs with sensitive = true where applicable.
- Do not commit .terraform folders or tfstate artifacts.

## 9. Non-Functional Requirements

- Readable and maintainable Terraform and documentation structure.
- Reproducible contributor workflow for branch promotion.
- Clear environment ownership and predictable variable resolution.

## 10. Acceptance Criteria

### AC-1 Branch Policy

Documentation and process enforce `feature/* -> main` as the default flow. No long-lived environment branches exist. Merging to main never triggers a Terraform run.

### AC-2 tfvars Layout

Environment variable files follow `environment/<env>/*.tfvars` pattern.

### AC-3 Workspace Targeting

Workspace configuration references one explicit tfvars path and avoids wildcard selection.

### AC-4 Security Baseline

No committed secrets in tfvars files and sensitive inputs are marked appropriately.

### AC-5 Documentation Consistency

AGENTS.md, CONTRIBUTING.md, and this specification describe the same GitFlow tfvars model.

## 11. Risks and Mitigations

- Risk: tfvars drift across environments.
  - Mitigation: isolate by folder and review changes through pull requests.
- Risk: accidental Terraform run against wrong environment.
  - Mitigation: environment is an explicit required input in the dispatch workflow; no automatic triggers.
- Risk: ambiguous runtime variable selection.
  - Mitigation: require one explicit workspace tfvars target path.

## 12. Change Control

Any change to this specification requires synchronized updates to:

- AGENTS.md
- docs/CONTRIBUTING.md
- Related repository documentation and workflow notes
