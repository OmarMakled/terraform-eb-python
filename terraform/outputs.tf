output "aws_region" {
  value = var.aws_region
}

output "application_name" {
  value = aws_elastic_beanstalk_application.app.name
}

output "environment_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}

output "s3_bucket_name" {
  value = aws_s3_bucket.eb_app_bucket.bucket
}