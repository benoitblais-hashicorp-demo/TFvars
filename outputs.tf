output "environment" {
  description = "The active deployment environment resolved from the workspace tfvars file."
  value       = var.environment
}

output "random_integer" {
  description = "A random integer generated within the configured min/max range."
  value       = random_integer.example.result
}
