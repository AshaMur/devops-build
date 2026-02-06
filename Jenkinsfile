pipeline {
    agent any
    environment {
        DOCKERHUB_USER = 'srinivasamurthym'
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKERHUB_USER/devops-build:latest .'
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
                branch 'master'
            }
            steps {
                sh 'docker tag $DOCKERHUB_USER/devops-build:latest $DOCKERHUB_USER/devops-build-prod:latest'
                sh 'docker push $DOCKERHUB_USER/devops-build-prod:latest'
            }
        }
        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }
}
