pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds') 
        DEV_IMAGE = "srinivasamurthym/dev"
        PROD_IMAGE = "srinivasamurthym/prod"
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}",
                    url: 'https://github.com/AshaMur/devops-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker build -t ${DEV_IMAGE}:${DOCKER_TAG} ."
                    } else if (env.BRANCH_NAME == 'main') {
                        sh "docker build -t ${PROD_IMAGE}:${DOCKER_TAG} ."
                    }
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker push ${DEV_IMAGE}:${DOCKER_TAG}"
                    } else if (env.BRANCH_NAME == 'main') {
                        sh "docker push ${PROD_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Cleanup Containers') {
            steps {
                script {
                    // Only clean dev container, leave prod untouched
                    sh "docker rm -f react-app-dev || true"
                }
            }
        }

        stage('Deploy Dev Container') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    sh "docker run -d --name react-app-dev -p 3001:80 ${DEV_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Skip Prod Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo "Prod deploy skipped. Live app on port 3000 remains untouched."
            }
        }

        stage('Cleanup Images/Networks') {
            steps {
                script {
                    sh "docker system prune -af || true"
                }
            }
        }
    }
}
