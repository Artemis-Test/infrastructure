#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT=${1:-staging}
SERVICE=${2:-all}

echo "Deploying ${SERVICE} to ${ENVIRONMENT}..."

aws ecs update-service \
  --cluster "artemis-test-${ENVIRONMENT}" \
  --service "${SERVICE}" \
  --force-new-deployment \
  --region us-east-1

echo "Deployment triggered."
