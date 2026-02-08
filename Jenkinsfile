pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    // Detect branch name
                    def branch = env.GIT_BRANCH ?: env.BRANCH_NAME

                    // Use Jenkins credentials for DockerHub login
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        // Decide tag based on branch
                        def tag = "latest"
                        if (branch.contains("dev")) {
                            tag = "dev"
                        } else if (branch.contains("prod")) {
                            tag = "prod"
                        }

                        // Build image
                        sh """
                        docker build -t $DOCKERHUB_USER/devops-build:${tag} .
                        """

                        // Login and push
                        sh """
                        echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                        docker push $DOCKERHUB_USER/devops-build:${tag}
                        """
                    }
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
