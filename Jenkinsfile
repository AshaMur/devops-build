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
                // Confirm Dockerfile is visible
                sh 'ls -l'
                // Build image from workspace root
                sh 'docker build -t $DOCKERHUB_USER
