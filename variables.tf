variable "environment" {
  description = "The target deployment environment. Value is sourced from the environment-scoped tfvars file."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, prod."
  }
}

variable "random_min" {
  description = "Minimum value for the random integer."
  type        = number
  default     = 1
}

variable "random_max" {
  description = "Maximum value for the random integer."
  type        = number
  default     = 100
}
