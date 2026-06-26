# Contributing

Thank you for contributing to this repository. This project demonstrates GitFlow with Terraform tfvars files, including environment-scoped variable files and controlled promotion across branches.

## Project Scope

Contributions should focus on:

- GitFlow branch behavior and promotion flow.
- Terraform variable management through tfvars files.
- Clear and safe environment separation.

Avoid introducing unrelated architecture changes unless explicitly requested.

## Branching and Promotion

This repository uses three long-lived branches:

- main: production-ready state.
- dev: integration branch for ongoing work.
- test: validation branch between dev and main.

Promotion path:

- dev -> test -> main

Do not bypass test when promoting changes unless maintainers explicitly approve an exception.

## tfvars Structure

All tfvars files must follow this directory model:

```text
environment/
	dev/
		*.tfvars
	test/
		*.tfvars
	prod/
		*.tfvars
```

Rules:

- Keep each environment isolated in its own subfolder.
- Prefer explicit file names that describe intent, such as app.tfvars.
- Keep values environment-appropriate and avoid copy-paste drift.

## Workspace Configuration

Workspace configuration must target one explicit tfvars file path.

Example:

- environment/dev/app.tfvars

Do not rely on wildcard selection for runtime variable files.

## Contribution Workflow

1. Create a feature branch from dev.
2. Make the smallest change needed for the target environment.
3. Keep documentation updated when structure or process changes.
4. Open a pull request into dev unless maintainers request a different target.
5. Promote via pull requests from dev to test, then test to main.

## Terraform Style

- Follow HashiCorp Terraform style conventions.
- Use snake_case for variable names and identifiers.
- Add type and description to variables.
- Prefer compatible version constraints for providers and modules.

## Validation

- If local tooling is available, run terraform fmt and terraform validate before opening a pull request.
- If local tooling is unavailable, ensure CI validation is green before merge.

## Security

- Never commit secrets in tfvars files.
- Use sensitive workspace variables or a secret backend for credentials.
- Do not commit .terraform folders or tfstate artifacts.
- Mark sensitive Terraform inputs with sensitive = true where applicable.

## Related Documentation

- Agent behavior and repository rules: ../AGENTS.md
- Security reporting process: SECURITY.md
