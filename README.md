# Udacity-DevOps-Capstone
## Project Overview
This is the Capstone project of Udacity Nanodegree course on AWS Cloud DevOps Engineer. It will create the CI/CD pipeline for micro services applications.

In this project, I have developed a CI/CD pipeline for Nginx Hello world application with `Blue/Green` deployment.

The `blue` branch has the code for `blue` deployment and `green` for `green` deployment.

All the screenshots are under `Screenshots` of this repository.
## Environment Setup

1. Launched EC2 instance - Installed Java, Jenkins, Docker, AWS CLI, Kubectl, eksctl, hadolint and tidy
2. Installed `pipeline-aws` and `Blue Ocean` plugins in Jenkins
3. Configure DockerHub and AWS credentials in Jenkins
4. Created EKS cluster using `eksctl`
5. Created `Dockerfile` for docker image
6. Created Jenkins CI/CD pipeline

## Steps Taken

1. Launched an EC2 free tier `ubuntu` instance with a Security Group allowing inbound connection on `22` and `8080` ports. Image I used is: ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026 (ami-0a4a70bd98c6d6441)
2. Login into EC2 instance using key/pair associated with instance . Install softwares using commands mentioned in `environment-setup.sh` file
3. Open Jenkins using `http://{public IP of EC2}:8080` in browser 
4. First time password is obtained using `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
5. Select option to install suggested plugin. // Not required if you use 20.0 ubuntu image
6. When installation is complete, you are prompted to set up the first admin user. Create the admin user and make note of both the user and password to use in the future. // Not required if you use 20.0 ubuntu image and default admin user is `admin`
7. Install `Blue Ocean` and `pipeline-aws` plugins via `Manage Jenkins => Manage Plugins => Search and install`.
8. Configure `AWS` and `DockerHub` Credentials in Jenkins via `Manage Jenkins => Manage Credentials => global => Add credentials`. These credentials will be used in `Jenkinsfile`. For `AWS` credentials Select `AWS Credentials` option in Kind dropdown and for DockerHub select `Username with password` option. The value which you put in `ID` field is used in `Jenkinsfile` to get credentials.
9. Restart the jenkins using `sudo systemctl restart jenkins`
10. Open your Github repository and add webhook to allow Jenkins to pick the changes via `Settings => Webhooks => Add webhook`. URL would be `http://{public IP of EC2}:8080/github-webhook/` and content-type `application/json`
11. Open `Blue Ocean` view in Jenkins and create a new pipeline for Github repository. You will need `Github access token` which can be generated via `Your github-profile => settings => Developer settings => Personal access tokens => Generate new token` with `repo` and `user:email` scope.
12. Commit changes in the `blue` branch which will trigger Jenkins pipeline to create and deploy container in EKS cluster.
13. Open the application using loadbalancer url: http://{loadbalancer dns}:8000/
    <p align="center">
        <img src="./blue-deployment.png">
    </p>
14. Commit changes in the `green` branch which will trigger Jenkins pipeline to create and deploy container in EKS cluster.
15. Open the application using loadbalancer url: http://{loadbalancer dns}:8000/
    <p align="center">
        <img src="./blue-deployment.png">
    </p>

## Repository details

1. `Dockerfile` contains the data to prepare image
2. `run_docker.sh` file is used to create docker image. It is invoked from `Makefile`.
3. `upload_docker.sh` file is used to upload docker image. It is invoked from `Makefile`.
4. `index.html` file is deployed in `nginx` server as part of web application
5. `ekscluster.yaml` file is used to create cluster using `eksctl` installed in EC2 instance
6. `environment-setup.sh` file has all the commands to be run on EC2 instance for initial setup
7. `Jenkinsfile` has the details of all the stages to be run as part of pipeline.
8. `Makefile` has the commands which are invoked from `Jenkinsfile`
9. `blue-green-service.json` file is used to make the blue or green deployment to be available. It is invoked form `Jenkinsfile`. Note that the selector, in this file, decides which environment will be up i.e. blue or green
10. `replication-controller.json` file is used to deploy image on cluster. It is invoked form `Jenkinsfile`.

## Steps to run locally 
<h4> https://medium.com/@andresaaap/simple-blue-green-deployment-in-kubernetes-using-minikube-b88907b2e267 </h4>
<br/>

1. Install `docker`, `virtualbox` and `minikube` at your local
2. Start `minikube` using command: `minikube start`
3. Build docker image using `run_docker.sh`
4. Upload docker image using `upload_docker.sh`
5. Deploy image using command: `kubectl apply -f ./replication-controller.json`
6. Switch to blue environment using command: `kubectl apply -f ./blue-green-service.json`
7. Get the application url using commandL: `minikube service bluegreenlb --url`
8. Open `url` in browser. 
