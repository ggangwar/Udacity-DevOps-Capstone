pipeline {
  agent any
  stages {
        stage('Kubernetes cluster') {
			steps {
				withAWS(region:'ap-south-1', credentials:'aws-credentials') {
					sh '''
						if aws cloudformation describe-stacks --stack-name eksctl-gg-devops-capstone-cluster; then
							echo 'eksctl-gg-devops-capstone-cluster stack already exists.'
						else
							echo 'eksctl-gg-devops-capstone-cluster stack is being created'
							eksctl create cluster \
							--name gg-devops-capstone \
							--version 1.18 \
							--nodegroup-name standard-workers \
							--node-type t2.micro \
							--nodes 2 \
							--nodes-min 1 \
							--nodes-max 3 \
							--node-ami auto \
							--region ap-south-1 \
							--zones ap-south-1a \
							--zones ap-south-1b \
							--zones ap-south-1c \
							which aws
							aws --version
							hostname
						fi
					'''
				}
			}
		}
    stage('Update Kube Config'){
      steps {
        withAWS(region:'ap-south-1',credentials:'aws-credentials') {
          sh 'aws eks --region ap-south-1 update-kubeconfig --name gg-devops-capstone'
          }
      }
    }
    stage('Set kubectl context') {
			steps {
				withAWS(region:'ap-south-1',credentials:'aws-credentials') {
					sh '''
            kubectl config get-contexts
						kubectl config use-context arn:aws:eks:ap-south-1:398230473428:cluster/gg-devops-capstone
					'''
				}
			}
		}
    stage('Linting') {
      steps {
        echo 'Linting code'
        script {
          sh 'make lint'
        }
      }
    }
    stage('Build docker image') {
      steps {
        echo 'Building docker image'
        script {
          sh 'make build'
        }
      }
    }
    stage('Login into Dockerhub') {
      steps {
        echo 'Login into Dockerhub'
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId:'docker-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
        sh 'docker login -u $USERNAME -p $PASSWORD'
        }
      }
    }
    stage('Push docker image') {
      steps {
        echo 'Pushing docker image'
        script {
          sh 'make upload'
        }
      }
    }
    stage('Deploy container') {
      steps {
        withAWS(region:'ap-south-1',credentials:'aws-credentials') {
          sh 'kubectl apply -f ./replication-controller.json'
          }
      }
    }
    stage("Docker clean") {
            steps {
                script {
                    sh "docker system prune --force"
                }
            }
    }
    stage('Redirect service') {
      steps {
        withAWS(region:'ap-south-1',credentials:'aws-credentials') {
          sh '''
            kubectl apply -f ./blue-green-service.json
            kubectl get pods
            kubectl describe pods
          '''
          }
      }
    }
  }
}