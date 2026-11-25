# Bootstrap Instructions

Use this script to create a Terraform backend bucket and bootstrap service account access.

## Usage

```bash
./bootstrap.sh playground-s-11-25ea42ed dev
```

Example:

```bash
./bootstrap.sh company-dev-2024 dev
```

The script creates:
- A GCS bucket for Terraform state
- A Terraform service account
- Basic IAM role binding
- Required GCP APIs
