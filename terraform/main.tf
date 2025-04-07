terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Minio Helm Release
resource "helm_release" "minio" {
  name       = "minio"
  repository = "./minio/chart/minio"
  chart      = "minio"
  namespace  = var.namespace

  set {
    name  = "minio.rootUser"
    value = jsondecode(data.google_secret_manager_secret_version.minio_credentials.secret_data)["root_user"]
  }

  set_sensitive {
    name  = "minio.rootPassword"
    value = jsondecode(data.google_secret_manager_secret_version.minio_credentials.secret_data)["root_password"]
  }

  set {
    name  = "persistence.size"
    value = var.minio_persistence_size
  }
}

# s3www Helm Release
resource "helm_release" "s3www" {
  name       = "s3www"
  repository = "./s3www/chart/s3www"
  chart      = "s3www"
  namespace  = var.namespace

  set {
    name  = "s3www.endpoint"
    value = var.s3www_endpoint
  }

  set {
    name  = "s3www.bucket"
    value = var.s3www_bucket
  }

  set_sensitive {
    name  = "s3www.accessKey"
    value = jsondecode(data.google_secret_manager_secret_version.s3www_credentials.secret_data)["access_key"]
  }

  set_sensitive {
    name  = "s3www.secretKey"
    value = jsondecode(data.google_secret_manager_secret_version.s3www_credentials.secret_data)["secret_key"]
  }

  depends_on = [helm_release.minio]
}

# Data sources to fetch existing secrets
data "google_secret_manager_secret_version" "minio_credentials" {
  secret  = var.minio_credentials_secret_id
  version = "latest"
}

data "google_secret_manager_secret_version" "s3www_credentials" {
  secret  = var.s3www_credentials_secret_id
  version = "latest"
} 