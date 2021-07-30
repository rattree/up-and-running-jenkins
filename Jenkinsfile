pipeline {
    agent any
    environment {
        LW_ACCESS_TOKEN = credentials('LW_ACCESS_TOKEN')
        LW_ACCOUNT_NAME = credentials('LW_ACCOUNT_NAME')
    }
    parameters {
        string (name: 'IMAGE_TAG',
                description: "Specify Image Tag",
                defaultValue: '')
    }
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
// added by me
        stage('Inline-Scan') {
            steps {
                echo 'Scanning image ...'
                sh "curl -L https://github.com/lacework/lacework-vulnerability-scanner/releases/latest/download/lw-scanner-linux-amd64 -o lw-scanner"
                sh "chmod +x lw-scanner"
                sh "./lw-scanner evaluate $ECR_REGISTRY_URL/lacework-cli ${IMAGE_TAG} --build-id ${BUILD_ID}"
                //sh "./lw-scanner evaluate  ${app} --build-id ${BUILD_ID}"
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
//         stage('Lacework Vulnerability Scan') {
//             environment {
//                 LW_API_SECRET = credentials('lacework_api_secret')
//             }
//             agent {
//                 docker { image 'lacework/lacework-cli:latest' }
//             }
//             when {
//                 branch 'master'
//             }
//             steps {
//                 echo 'Running Lacework vulnerability scan'
//                 sh "lacework vulnerability container scan 242313835346.dkr.ecr.us-west-2.amazonaws.com lacework-cli latest --poll --noninteractive --details"
//             }
//         }
     }
}
