variable "project_id" {
  type        = string
  description = "GCP project ID"
  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "project_id must not be empty"
  }
}

variable "region" {
  type        = string
  description = "GCP region"

  validation {
    condition     = can(regex("^[a-z]+(-[a-z]+)+[0-9]+$", var.region))
    error_message = "region must be a valid GCP region, for example: us-central1, asia-south1, europe-west1"
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  validation {
    condition     = var.environment == "dev" || var.environment == "stage" || var.environment == "prod"
    error_message = "environment must be dev, stage, or prod"
  }
}

variable "image_url" {
  type        = string
  description = "Artifact Registry image URL"
  validation {
    condition     = length(trimspace(var.image_url)) > 0
    error_message = "image_url must not be empty"
  }
}

variable "container_port" {
  type        = number
  description = "Container port"
  default     = 3000
}

variable "cpu" {
  type        = string
  description = "CPU allocation for Cloud Run"
  default     = "1"
}

variable "memory" {
  type        = string
  description = "Memory allocation for Cloud Run"
  default     = "512Mi"
}

variable "max_instance_count" {
  type        = number
  description = "Maximum number of Cloud Run instances"
  default     = 5
}

variable "secret_id" {
  type        = string
  description = "Secret Manager secret ID to mount"
  validation {
    condition     = length(trimspace(var.secret_id)) > 0
    error_message = "secret_id must not be empty"
  }
}

variable "service_account_email" {
  type        = string
  description = "Service account email for Cloud Run"
  validation {
    condition     = length(trimspace(var.service_account_email)) > 0
    error_message = "service_account_email must not be empty"
  }
}
