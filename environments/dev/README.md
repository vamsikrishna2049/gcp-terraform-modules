# GCP Infrastructure Setup Guide -

This guide explains how to authenticate with Google Cloud Platform (GCP), configure your project, enable the required APIs, create Terraform remote state storage, configure Artifact Registry, and build and push the Docker image.

## 1. Prerequisites

Ensure the following tools are installed:

- Google Cloud CLI (`gcloud`)
- Terraform
- Docker
- Access to a GCP project
- Required IAM permissions to enable APIs and create resources

Verify installations:

```
gcloud --version
terraform --version
docker --version
```

## 2. Authenticate with Google Cloud

### Step 1: Configure your GCP project

Replace `<your-gcp-project-id>` with your actual Google Cloud Project ID.

```
export PROJECT_ID="<your-gcp-project-id>"
```

### Step 2: Authenticate your Google account

```
gcloud auth login
```

### Step 3: Configure Application Default Credentials

```
gcloud auth application-default login
```

### Step 4: Set the active GCP project

```
gcloud config set project "$PROJECT_ID"
```

### Step 5: Set the quota project

```
gcloud auth application-default set-quota-project "$PROJECT_ID"
```

Verify the configuration:

```
gcloud config list
gcloud auth list
```

## 3. Enable Required GCP APIs

Enable the following Google Cloud services required for the infrastructure deployment.

```
gcloud services enable \
  compute.googleapis.com \
  sqladmin.googleapis.com \
  servicenetworking.googleapis.com \
  artifactregistry.googleapis.com \
  secretmanager.googleapis.com \
  run.googleapis.com \
  --project="$PROJECT_ID"
```

**Enabled APIs:**

| API                | Purpose                      |
| ------------------ | ---------------------------- |
| Compute Engine     | Compute infrastructure       |
| Cloud SQL Admin    | Cloud SQL management         |
| Service Networking | Private service connectivity |
| Artifact Registry  | Docker image storage         |
| Secret Manager     | Secure secret management     |
| Cloud Run          | Container deployment         |

## 4. Create GCS Terraform State Bucket

Create a Google Cloud Storage bucket to store Terraform remote state files.

```
gcloud storage buckets create \
  "gs://${PROJECT_ID}-terraform-state-dev" \
  --project="$PROJECT_ID" \
  --location=us-central1 \
  --uniform-bucket-level-access
```

**Configuration:**

- Bucket name: `${PROJECT_ID}-terraform-state-dev`
- Location: `us-central1`
- Access control: Uniform bucket-level access
- Purpose: Terraform remote state storage

> **Note:** For production use, consider enabling bucket versioning and configuring appropriate IAM permissions.

## 5. Create Artifact Registry Repository

Create a Docker repository in Google Artifact Registry.

```
gcloud artifacts repositories create dev-repo \
  --repository-format=docker \
  --location=us-central1 \
  --project="$PROJECT_ID"
```

Authenticate Docker with Artifact Registry:

```
gcloud auth configure-docker us-central1-docker.pkg.dev --quiet
```

## 6. Build and Push Docker Image

Navigate to the Cloud SQL Secret Rotator service directory.

```
cd services/cloudsql-secret-rotator
```

### Step 1: Build the Docker image

```
docker build \
  -t "us-central1-docker.pkg.dev/${PROJECT_ID}/dev-repo/cloudsql-secret-rotator:latest" \
  .
```

### Step 2: Push the Docker image

```
docker push \
  "us-central1-docker.pkg.dev/${PROJECT_ID}/dev-repo/cloudsql-secret-rotator:latest"
```

### Docker Image Details
| -------------------------------------- |
| Property   | Value                     |
| -------------------------------------- |
| Registry   | Artifact Registry         |
| Location   | `us-central1`             |
| Repository | `dev-repo`                |
| Image      | `cloudsql-secret-rotator` |
| Tag        | `latest`                  |
| -------------------------------------- |
## 7. Verify Docker Image

Confirm that the image has been successfully uploaded.

```
gcloud artifacts docker images list \
  "us-central1-docker.pkg.dev/${PROJECT_ID}/dev-repo"
```

## 8. Setup Completion Checklist

- Google Cloud CLI installed
- Google account authenticated
- Application Default Credentials configured
- GCP project configured
- Required GCP APIs enabled
- Terraform state bucket created
- Artifact Registry repository created
- Docker authentication configured
- Docker image built successfully
- Docker image pushed to Artifact Registry

---

**Infrastructure setup is complete!**

The GCP project is now prepared with the required APIs, Terraform state storage, Artifact Registry repository, and container image.

One recommendation: Before using this in production, add Terraform state bucket versioning, IAM least-privilege permissions, and a clear environment-specific configuration for Dev, QA, and Production.