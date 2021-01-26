#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
# dockerpath=<your docker ID/path>
dockerpath="ggangwar/gg-devops-capstone-green"
# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
docker tag gg-devops-capstone-green $dockerpath
docker login --username ggangwar
# Step 3:
# Push image to a docker repository
docker push $dockerpath