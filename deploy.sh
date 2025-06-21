#!/bin/bash

set -e

export AWS_PAGER=""

TERRAFORM_DIR="terraform"
ZIP_FILE="app.zip"
APP_DIR="app"

echo "Reading Terraform outputs..."
AWS_REGION=$(terraform -chdir=$TERRAFORM_DIR output -raw aws_region)
S3_BUCKET_NAME=$(terraform -chdir=$TERRAFORM_DIR output -raw s3_bucket_name)
APPLICATION_NAME=$(terraform -chdir=$TERRAFORM_DIR output -raw application_name)
ENVIRONMENT_NAME="${APPLICATION_NAME}-env"
VERSION_LABEL="v$(date +%Y%m%d%H%M%S)"

echo "Zipping application files..."
(cd "$APP_DIR" && zip -r "../${ZIP_FILE}" .)

echo "Uploading ${ZIP_FILE} to S3 bucket: ${S3_BUCKET_NAME}"
aws s3 cp "${ZIP_FILE}" "s3://${S3_BUCKET_NAME}/" --region "$AWS_REGION"

echo "Creating new Elastic Beanstalk application version: ${VERSION_LABEL}"
aws elasticbeanstalk create-application-version \
  --application-name "${APPLICATION_NAME}" \
  --version-label "${VERSION_LABEL}" \
  --source-bundle S3Bucket="${S3_BUCKET_NAME}",S3Key="${ZIP_FILE}" \
  --region "${AWS_REGION}"

echo "Updating environment ${ENVIRONMENT_NAME} with new version ${VERSION_LABEL}"
aws elasticbeanstalk update-environment \
  --environment-name "${ENVIRONMENT_NAME}" \
  --version-label "${VERSION_LABEL}" \
  --region "${AWS_REGION}"

rm "${ZIP_FILE}"
echo "Deployment complete!"

ENV_URL=$(terraform -chdir=$TERRAFORM_DIR output -raw environment_url)
echo "✅ Application is live at: http://${ENV_URL}"