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
    stage('Deploy container') {
      steps {
        echo 'Deploying container'
        sh 'make deploy'
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