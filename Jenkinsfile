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

        stage('Deploy Container') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker rm -f react-app-dev || true"
                        sh "docker run -d --name react-app-dev -p 3001:80 ${DEV_IMAGE}:${DOCKER_TAG}"
                    } else if (env.BRANCH_NAME == 'main') {
                        sh "docker rm -f react-app-prod || true"
                        sh "docker run -d --name react-app-prod -p 3000:80 ${PROD_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    sh "docker system prune -af || true"
                }
            }
        }
    }
}
