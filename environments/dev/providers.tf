terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "playground-s-11-6c20b94e-terraform-state-dev"
    prefix = "dev/state"
  }
}

provider "google" {
  project = "playground-s-11-6c20b94e"
  region  = "us-central1"
  zone    = "us-central1-a"
}
