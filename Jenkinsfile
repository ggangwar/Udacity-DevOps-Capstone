pipeline {
  agent any
  stages {
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
    stage('Update Kube Config'){
      steps {
        withAWS(region:'ap-south-1',credentials:'aws-credentials') {
          sh 'aws eks --region ap-south-1 update-kubeconfig --name gg-devops-capstone'
          }
      }
    }
    stage('Deploy container') {
      steps {
        sh 'kubectl apply -f ./kubernetes'
      }
    }
    stage('Redirect service') {
      steps {
        echo 'Redirecting service'
        sh 'make redirect'
      }
    }
  }
}