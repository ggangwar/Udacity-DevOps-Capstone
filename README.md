# Udacity-DevOps-Capstone

<h2>Project Overview</h2>
This is the Capstone project of Udacity Nanodegree course on AWS Cloud DevOps Engineer. It will create the CI/CD pipeline for micro services applications.

In this project, I have developed a CI/CD pipeline for Nignx Hello world application with Blue/Green deployment.

<h2>Environment Setup</h2>
<ul>
    <li>Launched EC2 instance - Installed Java, Jenkins, Docker, AWS CLI, Kubectl, eksctl, hadolint and tidy</li>
    <li>Installed pipeline-aws and Blue Ocean plugins in Jenkins</li>
    <li>Configure DockerHub and AWS credentials in Jenkins</li>
    <li>Created EKS cluster using eksctl</li>
    <li>Created Dockerfile for docker image</li>
    <li>Created Jenkins CI/CD pipeline</li>
</ul>

<h2>Steps Taken</h2>
<ul>
    <li>Launched an EC2 free tier ubuntu instance with a Security Group allowing inbound connection on 22 and 8080 ports.</li>
    <li>Login into EC2 instance using key/pair associated with instance . Install softwares using commands mentioned in environment-setup.sh file</li>
    <li>Open Jenkins using http://{public IP of EC2}:8080 in browser </li>
    <li>First time password is obtained using sudo cat /var/lib/jenkins/secrets/initialAdminPassword</li>
    <li>Select option to install suggested plugin</li>
    <li>When installation is complete, you are prompted to set up the first admin user. Create the admin user and make note of both the user and password to use in the future.</li>
    <li>Install "Blue Ocean" and "pipeline-aws" plugins via "Manage Jenkins" => "Manage Plugins" => "Search and install".</li>
    <li>Configure AWS and DockerHub Credentials in Jenkins via "Manage Jenkins" => "Manage Credentials" => "global" => "Add credentials". These credentials will be used in Jenkinsfile.</li>
    <li>Restart the jenkins using sudo systemctl restart jenkins</li>
    <li>Copy the ekscluster.yaml on EC2 instance at some location e.g. scp -i "yourpemfile" ubuntu@public-ip:/home/ubuntu</li>
    <li>Create cluster by running this command on EC2: eksctl create cluster -f /home/ubuntu/ekscluster.yaml</li>
    <li>Open your Github repository and add webhook to allow Jenkins to pick the changes via Settings => Webhooks => Add webhook. URL would be http://{public IP of EC2}:8080/github-webhook/ and content-type application/json</li>
    <li>Open Blue Ocean view in Jenkins and create pipeline for Github repository. You can generate token via Your github-profile => settings => Developer settings => Personal access tokens => Generate new token.</li>
    <li>Commit changes in the blue branch which will trigger Jenkins pipeline to create and deploy container in EKS cluster</li>
    <li>Commit changes in the green branch which will trigger Jenkins pipeline to create and deploy container in EKS cluster</li>
</ul>

<h2>Repository details</h2>

<ul>
    <li>Dockerfile contains the data to prepare image</li>
    <li>run_docker.sh file is used to create docker image. It is invoked from Makefile.</li>
    <li>upload_docker.sh file is used to upload docker image. It is invoked from Makefile.</li>
    <li>index.html file is deployed in nginx server as part of web application</li>
    <li>ekscluster.yaml file is used to create cluster using eksctl installed in EC2 instance</li>
    <li>environment-setup.sh file has all the commands to be run on EC2 instance for initial setup</li>
    <li>Jenkinsfile has the details of all the stages to be run as part of pipeline.</li>
    <li>Makefile has the commands which are invoked from Jenkinsfile</li>
    <li>blue-green-service.json file is used to make the blue or green deployment to be available. It is invoked form Jenkinsfile. Note that the selector, in this file, decides which environment will be up i.e. blue or green</li>
    <li>replication-controller.json file is used to deploy image on cluster. It is invoked form Jenkinsfile.</li>
</ul>

<h2>Steps to run locally</h2> 
<h4> https://medium.com/@andresaaap/simple-blue-green-deployment-in-kubernetes-using-minikube-b88907b2e267 </h4>
<br/>
<ul>
    <li>Install docker, virtualbox and minikube at your local</li>
    <li>Start minikube using command: minikube start</li>
    <li>Build docker image using run_docker.sh</li>
    <li>Upload docker image using upload_docker.sh</li>
    <li>Deploy image using command: kubectl apply -f ./replication-controller.json</li>
    <li>Switch to blue environment using command: kubectl apply -f ./blue-green-service.json</li>
    <li>Get the application url using commandL: minikube service bluegreenlb --url</li>
    <li>Open url in browser. </li>
</ul>