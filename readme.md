### 🚀 Deploy a Python App to AWS with Elastic Beanstalk & Terraform

This project demonstrates how to deploy a simple Python application to AWS using Elastic Beanstalk for managed hosting and Terraform for infrastructure as code. Terraform provisions all necessary AWS resources (like S3, IAM roles, and the Elastic Beanstalk environment), while the deploy.sh script automates packaging, uploading, and updating the application.

```
terraform init
terraform apply
```

```
./deploy.sh
```