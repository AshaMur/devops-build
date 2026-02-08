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
                    def branch = env.GIT_BRANCH ?: env.BRANCH_NAME

                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        // Decide tag and Dockerfile based on branch
                        def tag = "latest"
                        def dockerfile = "Dockerfile"

                        if (branch.contains("dev")) {
                            tag = "dev"
                            dockerfile = "Dockerfile.deploy"
                        } else if (branch.contains("prod")) {
                            tag = "prod"
                            dockerfile = "Dockerfile.deploy"
                        }

                        // Build image with BuildKit enabled
                        sh """
                        DOCKER_BUILDKIT=1 docker build -f ${dockerfile} -t $DOCKERHUB_USER/devops-build:${tag} .
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
