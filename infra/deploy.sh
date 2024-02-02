#!/bin/bash

# Generate YAML from CDK:
# cdk synth --profile sandbox > erp.yaml

# Deploy the stack.
aws cloudformation deploy --template-file erp.yaml --stack-name PhoERPStack --capabilities CAPABILITY_NAMED_IAM --profile sandbox

# Delete the stack.
aws cloudformation delete-stack --stack-name PhoERPStack --profile sandbox

# Does the bucket exist?
aws s3 ls --profile sandbox | grep org.treytomes.web-bucket

# List bucket contents.
aws s3 ls s3://org.treytomes.web-bucket --profile sandbox

# Copy a file down from the bucket.
aws s3 cp s3://org.treytomes.web-bucket/index.html . --profile sandbox

# Copy a file up to S3.
aws s3 cp ./LICENSE s3://org.treytomes.web-bucket --profile sandbox
