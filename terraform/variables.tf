variable "namespace" {
  description = "Kubernetes namespace to deploy the applications"
  type        = string
  default     = "default"
}

variable "minio_persistence_size" {
  description = "Size of the Minio persistent volume"
  type        = string
  default     = "10Gi"
}

variable "s3www_endpoint" {
  description = "Minio endpoint for s3www"
  type        = string
  default     = "http://minio:9000"
}

variable "s3www_bucket" {
  description = "S3 bucket name for s3www"
  type        = string
  default     = "up42"
}

variable "gcp_project_id" {
  description = "GCP project ID where resources will be created"
  type        = string
}

variable "gcp_region" {
  description = "GCP region where resources will be created"
  type        = string
  default     = "us-central1"
}

variable "minio_credentials_secret_id" {
  description = "ID of the existing Minio credentials secret in GCP Secret Manager"
  type        = string
  default     = "projects/up42-dev/secrets/minio-credentials/versions/latest" ## TODO: Make use of Terraform workspace to set the correct secret id
}

variable "s3www_credentials_secret_id" {
  description = "ID of the existing s3www credentials secret in GCP Secret Manager"
  type        = string
  default     = "projects/up42-dev/secrets/s3www-credentials/versions/latest" ## TODO: Make use of Terraform workspace to set the correct secret id
}

variable "environment" {
  description = "Environment name for resource naming"
  type        = string
  default     = "dev"
} 