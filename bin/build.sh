#!/bin/bash

# Inspiration from https://github.com/onnimonni/terraform-ecr-docker-build-module

# Fail fast
set -e

# This is the order of arguments
build_folder=$1
aws_ecr_repository_url_with_tag=$2

# Check that aws is installed
which aws > /dev/null || { echo 'ERROR: aws-cli is not installed' ; exit 1; }

# Connect into aws
token=$(aws ecr get-login-password --region "$AWS_REGION")
docker login -u AWS -p "$token" "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com" || { echo 'ERROR: docker login' ; exit 1; }

# Check that docker is installed and running
which docker > /dev/null && docker ps > /dev/null || { echo 'ERROR: docker is not running' ; exit 1; }

# Some Useful Debug
echo "Building $aws_ecr_repository_url_with_tag from $build_folder/Dockerfile"

# Build image
docker build -t $aws_ecr_repository_url_with_tag $build_folder

# Push image
docker push $aws_ecr_repository_url_with_tag
