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
                sh 'ls -l'  // debug: confirm Dockerfile is present
                sh 'DOCKER_BUILDKIT=0 docker build -t $DOCKERHUB_USER/devops-build:latest .'
            }
        }

        stage('Push to Dev Repo') {
            when {
                branch 'dev'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker tag $DOCKERHUB_USER/devops-build:latest $DOCKERHUB_USER/devops-build-dev:latest'
                    sh 'docker push $DOCKERHUB_USER/devops-build-dev:latest'
                }
            }
        }

        stage('Push to Prod Repo') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker tag $DOCKERHUB_USER/devops-build:latest $DOCKERHUB_USER/devops-build-prod:latest'
                    sh 'docker push $DOCKERHUB_USER/devops-build-prod:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }
}
