def COLOR_MAP = [
    SUCCESS: 'good', 
    FAILURE: 'danger',
]

pipeline {
    agent any
    tools {
        nodejs "nodejs"
        jdk "OracleJDK8"
    }
    
    environment {
        acrServer = 'liferythem.azurecr.io'
        acrCredential = 'acr-cred' // Jenkins credential ID for ACR
    }

    stages {
        stage('Build') {
            steps {
                // sh 'npm install'
                echo "Build"
            }
        }

        stage('Test') {
            steps {
               // sh 'mvn test'
               echo "Test"
            }
        }

        stage('Build App Image') {
            steps {
                sh 'docker image build -t liferythem.azurecr.io/mycarimage:${BUILD_NUMBER} .'
            }
        }
            
        stage('Upload App Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'acr-creds', passwordVariable: 'password', usernameVariable: 'username')]) {
                    sh "docker login -u ${username} -p ${password} liferythem.azurecr.io"
                    sh "docker image push liferythem.azurecr.io/mycarimage:${BUILD_NUMBER}"
                }
            }
        }

        stage('Delete Docker Image and Resources') {
            steps {
                script {
                    // Delete the Docker image locally
                    // sh 'docker rmi your-image-name:latest'
                    // dockerImage.remove()
                    // echo 'docker image rm 501715535647.dkr.ecr.us-east-1.amazonaws.comcarshowcaseimg:$BUILD_NUMBER '
                    // echo "docker image rm 501715535647.dkr.ecr.us-east-1.amazonaws.com/carshowcaseimg:\$BUILD_NUMBER"
                    echo "docker image rm liferythem.azurecr.io/mycarimage:${BUILD_NUMBER}"
                    sh "docker image rm liferythem.azurecr.io/mycarimage:${BUILD_NUMBER}"
                    // sh 'docker image rm 501715535647.dkr.ecr.us-east-1.amazonaws.com/carshowcaseimg:$BUILD_NUMBER'
                    // Optionally, clean up other resources associated with the build
                    // For example, remove volumes, containers, etc.
                    // sh 'docker rm -v your-container-id'
                }
            }
        } 
    }
  
    post {
        always {
            cleanWs()
            echo 'Slack Notifications.'
            slackSend channel: '#vprofilecicd',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }
}
