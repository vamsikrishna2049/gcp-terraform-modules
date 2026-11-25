module "vm_cloudsql_stack" {
  source = "../../modules/vm-cloudsql-stack"

  project_id            = "playground-s-11-6c20b94e"
  region                = "us-central1"
  zone                  = "us-central1-a"
  environment           = "dev"
  cidr_block            = "10.0.0.0/16"
  public_cidr           = "10.0.1.0/24"
  private_cidr          = "10.0.2.0/24"
  data_cidr             = "10.0.3.0/24"
  vm_names              = ["app-vm-1"]
  machine_type          = "e2-micro"
  db_instance_name      = "dev-postgres-db"
  db_password_secret_id = "dev-db-password"
  domain_name           = "dev.example.com"
}


module "secret_manager" {
  source      = "../../modules/secret-manager"
  project_id  = "playground-s-11-6c20b94e"
  environment = "dev"

  secret_configs = {
    dev-app-secret = {
      secret_data = "InitialAppSecret123!"
      labels = {
        env = "dev"
      }
    }
  }
}

module "cloud_run" {
  max_instance_count    = 1
  source                = "../../modules/cloud-run"
  project_id            = "playground-s-11-6c20b94e"
  region                = "us-central1"
  environment           = "dev"
  image_url             = "us-central1-docker.pkg.dev/playground-s-11-6c20b94e/dev-repo/cloudsql-secret-rotator:latest"
  secret_id             = "dev-db-password"
  service_account_email = "terraform-dev@playground-s-11-6c20b94e.iam.gserviceaccount.com"
}

# module "secret_rotation" {
#   source                  = "../../modules/secret-rotation"
#   project_id              = "playground-s-11-6c20b94e"
#   region                  = "us-central1"
#   environment             = "dev"
#   rotation_service_image  = "us-central1-docker.pkg.dev/playground-s-11-6c20b94e/dev-repo/cloudsql-secret-rotator:latest"
#   cloud_sql_instance_name = "dev-postgres-db"
#   secret_id               = "dev-db-password"
# }
