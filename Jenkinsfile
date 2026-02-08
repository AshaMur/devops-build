pipeline {
    agent any
    stages {
        stage('Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh """
                    docker build -t $DOCKERHUB_USER/devops-build:${env.BRANCH_NAME} .
                    echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                    docker push $DOCKERHUB_USER/devops-build:${env.BRANCH_NAME}
                    """
                }
            }
        }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def branch = env.GIT_BRANCH ?: env.BRANCH_NAME

                    if (branch == 'main') {
                        // Full multi-stage build
                        sh """
                        docker build -t $DOCKERHUB_USER/devops-build:latest .
                        """
                    } else {
                        // Deployment-only build (serve prebuilt build/ folder)
                        sh """
                        docker build -f Dockerfile.deploy -t $DOCKERHUB_USER/devops-build:${branch} .
                        """
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh """
                    echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                    docker push $DOCKERHUB_USER/devops-build:latest || true
                    docker push $DOCKERHUB_USER/devops-build:${env.GIT_BRANCH}
                    """
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
