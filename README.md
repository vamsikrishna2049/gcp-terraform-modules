# GCP Terraform Modules

Reusable Terraform modules for GCP infrastructure including networking, VMs, Cloud SQL, secret management, secret rotation, Cloud Run, and load balancing.

## Structure

- `modules/network`
- `modules/compute-vm`
- `modules/cloud-sql-postgres`
- `modules/secret-manager`
- `modules/secret-rotation`
- `modules/cloud-run`
- `modules/load-balancer`
- `modules/vm-cloudsql-stack`
- `bootstrap`
- `services/cloudsql-secret-rotator`
- `tests/network_test`

## Usage

Each module provides a `README.md` with inputs, outputs, and resource details. Use the `bootstrap/bootstrap.sh` script to set up initial state buckets and service accounts.








cat << 'EOF' > /workspaces/gcp-terraform-modules/README.md
# GCP Terraform Modules

Modular, multi-tier Google Cloud Platform (GCP) infrastructure managed with Terraform, paired with a containerized Python 3.11 service deployed to Cloud Run via Google Artifact Registry.

## Architecture Overview

```text
Internet ──► External Load Balancer ──► Compute VM (Private VPC) ──► Cloud SQL (PostgreSQL, Private IP)
                                               │
                                        Cloud Router / NAT

Artifact Registry ──► Cloud Run v2 (app-service-dev) ──► Secret Manager (us-central1)
                                                                ▲
                                         Eventarc / Scheduler ──┴── Cloud Run v2 (secret-rotation)





