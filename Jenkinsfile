def COLOR_MAP = [
    'SUCCESS': 'good', 
    'FAILURE': 'danger',
]

pipeline {
    agent any
    tools {
        node "nodejs"
        jdk "OracleJDK8"
    }
    
    environment {
        // SNAP_REPO = 'vprofile-snapshot'
		// NEXUS_USER = 'admin'
		// NEXUS_PASS = 'admin123'
		// RELEASE_REPO = 'vprofile-release'
		// CENTRAL_REPO = 'vpro-maven-central'
		// NEXUSIP = '172.31.88.91'
		// NEXUSPORT = '8081'
		// NEXUS_GRP_REPO = 'vpro-maven-group'
        // NEXUS_LOGIN = 'nexuslogin'
        // SONARSERVER = 'sonarserver'
        //SONARSCANNER = 'sonarscanner'
	registryCredential = 'ecr:us-east-1:awscred'
        appRegistry = '501715535647.dkr.ecr.us-east-1.amazonaws.com/carshowcaseimg'
        vprofileRegistry = "https://501715535647.dkr.ecr.us-east-1.amazonaws.com" 
        // cluster = "vprostaging"
        // service = "vproappstagesvc"
    }

    stages {
        stage('Build'){
            steps {
                sh 'npm install'
            }
        }

        stage('Test'){
            steps {
               // sh 'mvn test'
               echo "Test"
            }

        }

         stage('Build App Image') {
            steps {
                script {
                    dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", ".")
                }
            }
        }
        
        stage('Upload App Image') {
          steps{
            script {
              docker.withRegistry( vprofileRegistry, registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
        }   
    }  
post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#vprofilecicd',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }
	
}