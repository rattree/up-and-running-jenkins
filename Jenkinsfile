pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build("$ECR_REGISTRY_URL/lacework-cli")
                    app.inside {
                        sh 'lacework --help'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://242313835346.dkr.ecr.us-west-2.amazonaws.com', 'ecr:us-west-2:my-aws-cred') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('Lacework Vulnerability Scan') {
            environment {
                LW_API_SECRET = credentials('lacework_api_secret')
            }
            when {
                branch 'master'
            }
            steps {
                echo 'Running Lacework vulnerability scan'
                sh "lacework vulnerability container scan 242313835346.dkr.ecr.us-west-2.amazonaws.com $ECR_REGISTRY_URL/lacework-cli latest --poll --noninteractive --details"
            }
        }
    }
}
