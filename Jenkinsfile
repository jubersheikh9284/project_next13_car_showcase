def COLOR_MAP = [
    'SUCCESS': 'good', 
    'FAILURE': 'danger',
]

pipeline {
    agent any
    tools {
         nodejs 'nodejs'
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
        cluster = "vrostagging"
        service = "vproappstagesvc"
    }

    stages {
        stage('Build'){
            steps {
                //sh 'npm install'
		    echo "Build"
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
                    dockerImage = docker.build( appRegistry + ":30", ".")
                }
            }
        }
        
        stage('Upload App Image') {
          steps{
            script {
              docker.withRegistry( vprofileRegistry, registryCredential ) {
              dockerImage.push(appRegistry + ":30")
               
              }
            }
          }
        }  

   //       stage('Delete Docker Image and Resources') {
   //          steps {
   //              script {
   //                  // Delete the Docker image locally
   //                 // sh 'docker rmi your-image-name:latest'
   //                //  dockerImage.remove()
   //                  sh 'docker image rm 501715535647.dkr.ecr.us-east-1.amazonaws.com/carshowcaseimg'
			// // Optionally, clean up other resources associated with the build
   //                  // For example, remove volumes, containers, etc.
   //                  // sh 'docker rm -v your-container-id'
   //              }
   //          }
   //      } 
    }
       
post {
        always {
script {
            echo 'Slack Notifications.'
            slackSend channel: '#vprofilecicd',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"

            cleanWs(cleanWhenNotBuilt: true,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])
            
            // Remove Docker images
           // if (dockerImage) {
           //      def existingImage = docker.image(dockerImage.id)
           //      if (existingImage.exists()) {
           //          echo "Docker image exists. Removing..."
           //          existingImage.remove()
           //          echo "Docker image removed."
           //      } else {
           //          echo "Docker image does not exist. No need to remove."
           //      }
           //  }
        }
    }
	
}
}
