#!/usr/bin/env bash
# One-time GCP setup for .github/workflows/deploy.yml. Run by someone with Owner (or
# IAM Admin + Secret Manager Admin) on the project, with the licence file at hand:
#
#   bash deploy/gcp-setup.sh /path/to/syside-license.lic
#
# Re-running is safe: each create step is skipped when the resource exists. A re-run
# with a licence file adds it as a new version of the secret.
set -euo pipefail

LICENSE_FILE="${1:?usage: $0 /path/to/syside-license.lic}"
[ -f "$LICENSE_FILE" ] || { echo "no such file: $LICENSE_FILE" >&2; exit 1; }

PROJECT_ID=detect-sysmlv2
REGION=us-central1
GITHUB_REPO=sensmetry/detect
AR_REPO=detect
SECRET=syside-license
DEPLOY_SA="github-deploy@${PROJECT_ID}.iam.gserviceaccount.com"
RUNTIME_SA="detect-webapp-runtime@${PROJECT_ID}.iam.gserviceaccount.com"
POOL=github
PROVIDER=github

PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format='value(projectNumber)')

gcloud services enable --project "$PROJECT_ID" \
  run.googleapis.com artifactregistry.googleapis.com secretmanager.googleapis.com \
  iamcredentials.googleapis.com sts.googleapis.com

# Image repository.
gcloud artifacts repositories describe "$AR_REPO" --project "$PROJECT_ID" --location "$REGION" >/dev/null 2>&1 \
  || gcloud artifacts repositories create "$AR_REPO" --project "$PROJECT_ID" --location "$REGION" \
       --repository-format docker

# Licence secret.
if gcloud secrets describe "$SECRET" --project "$PROJECT_ID" >/dev/null 2>&1; then
  gcloud secrets versions add "$SECRET" --project "$PROJECT_ID" --data-file "$LICENSE_FILE"
else
  gcloud secrets create "$SECRET" --project "$PROJECT_ID" --replication-policy automatic \
    --data-file "$LICENSE_FILE"
fi

# Service accounts.
gcloud iam service-accounts describe "$RUNTIME_SA" --project "$PROJECT_ID" >/dev/null 2>&1 \
  || gcloud iam service-accounts create detect-webapp-runtime --project "$PROJECT_ID" \
       --display-name "detect-webapp Cloud Run runtime"
gcloud iam service-accounts describe "$DEPLOY_SA" --project "$PROJECT_ID" >/dev/null 2>&1 \
  || gcloud iam service-accounts create github-deploy --project "$PROJECT_ID" \
       --display-name "GitHub Actions deployer for ${GITHUB_REPO}"

# The running service may read the licence and nothing else.
gcloud secrets add-iam-policy-binding "$SECRET" --project "$PROJECT_ID" \
  --member "serviceAccount:${RUNTIME_SA}" --role roles/secretmanager.secretAccessor

# The deployer may push images, deploy Cloud Run services, and run them as the runtime SA.
gcloud artifacts repositories add-iam-policy-binding "$AR_REPO" --project "$PROJECT_ID" --location "$REGION" \
  --member "serviceAccount:${DEPLOY_SA}" --role roles/artifactregistry.writer
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member "serviceAccount:${DEPLOY_SA}" --role roles/run.admin --condition None
gcloud iam service-accounts add-iam-policy-binding "$RUNTIME_SA" --project "$PROJECT_ID" \
  --member "serviceAccount:${DEPLOY_SA}" --role roles/iam.serviceAccountUser

# Workload Identity Federation: only pushes to main of $GITHUB_REPO can act as the deployer.
gcloud iam workload-identity-pools describe "$POOL" --project "$PROJECT_ID" --location global >/dev/null 2>&1 \
  || gcloud iam workload-identity-pools create "$POOL" --project "$PROJECT_ID" --location global \
       --display-name "GitHub Actions"
gcloud iam workload-identity-pools providers describe "$PROVIDER" --project "$PROJECT_ID" --location global \
    --workload-identity-pool "$POOL" >/dev/null 2>&1 \
  || gcloud iam workload-identity-pools providers create-oidc "$PROVIDER" --project "$PROJECT_ID" \
       --location global --workload-identity-pool "$POOL" \
       --issuer-uri https://token.actions.githubusercontent.com \
       --attribute-mapping 'google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.ref=assertion.ref' \
       --attribute-condition "assertion.repository == '${GITHUB_REPO}' && assertion.ref == 'refs/heads/main'"
gcloud iam service-accounts add-iam-policy-binding "$DEPLOY_SA" --project "$PROJECT_ID" \
  --role roles/iam.workloadIdentityUser \
  --member "principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL}/attribute.repository/${GITHUB_REPO}"

echo
echo "Set this GitHub repository variable on ${GITHUB_REPO} (Settings > Secrets and variables > Actions > Variables):"
echo "  GCP_WORKLOAD_IDENTITY_PROVIDER = projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL}/providers/${PROVIDER}"
