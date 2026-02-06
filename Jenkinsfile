pipeline {
    agent any
    environment {
        DOCKERHUB_USER = 'srinivasamurthym'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                dir('devops-build') {
                    sh 'docker build -t $DOCKERHUB_USER/devops-build:latest .'
                }
            }
        }
        stage('Push to Dev Repo') {
            when {
                branch 'dev'
            }
            steps {
                sh 'docker tag $DOCKERHUB_USER/devops-build:latest $DOCKERHUB_USER/devops-build-dev:latest'
                sh 'docker push $DOCKERHUB_USER/devops-build-dev:latest'
            }
        }
        stage('Push to Prod Repo') {
            when {
                branch 'main'
            }
            steps {
                sh 'docker tag $DOCKERHUB_USER/devops-build:latest $DOCKERHUB_USER/devops-build-prod:latest'
                sh 'docker push $DOCKERHUB_USER/devops-build-prod:latest'
            }
        }
        stage('Deploy') {
            steps {
                dir('devops-build') {
                    sh './deploy.sh'
                }
            }
        }
    }
}
