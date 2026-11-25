Authenticate and set your project:

export PROJECT_ID="<your-gcp-project-id>"
gcloud auth login
gcloud auth application-default login
gcloud config set project "$PROJECT_ID"
gcloud auth application-default set-quota-project "$PROJECT_ID"


Enable required GCP APIs:
gcloud services enable \
  compute.googleapis.com \
  sqladmin.googleapis.com \
  servicenetworking.googleapis.com \
  artifactregistry.googleapis.com \
  secretmanager.googleapis.com \
  run.googleapis.com \
  --project="$PROJECT_ID"

'''
Create the GCS state bucket, Artifact Registry repo, and push the container image:
'''
  gcloud storage buckets create "gs://${PROJECT_ID}-terraform-state-dev" \
  --project="$PROJECT_ID" \
  --location=us-central1 \
  --uniform-bucket-level-access

gcloud artifacts repositories create dev-repo \
  --repository-format=docker \
  --location=us-central1 \
  --project="$PROJECT_ID"

gcloud auth configure-docker us-central1-docker.pkg.dev --quiet

cd services/cloudsql-secret-rotator
docker build -t "us-central1-docker.pkg.dev/${PROJECT_ID}/dev-repo/cloudsql-secret-rotator:latest" .
docker push "us-central1-docker.pkg.dev/${PROJECT_ID}/dev-repo/cloudsql-secret-rotator:latest"