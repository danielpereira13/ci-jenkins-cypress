pipeline {
  agent {
    // this image provides everything needed to run Cypress
    docker {
      image 'cypress/base:10'
      // image 'cypress/included:4.8.0'
    }
  }

  options {
    // Only keep the 3 most recent builds
    buildDiscarder(logRotator(numToKeepStr:'3'))
  }
  stages {
    // first stage installs node dependencies and Cypress binary
    stage('build') {
      steps {
        // there a few default environment variables on Jenkins
        // on local Jenkins machine (assuming port 8080) see
        // http://localhost:8080/pipeline-syntax/globals#env
        echo "Running build ${env.BUILD_ID} on ${env.JENKINS_URL}"
        sh 'hostname'
        sh 'npm install'
        //sh 'npm run cy:verify'
      }
    }
    stage ('Test - Electron') {
      steps {
        sh 'npm run cypress'
      }
      post {
        always {
          sh 'npm run after:tests'
        }
        failure {
          archiveArtifacts allowEmptyArchive: true, artifacts: 'cypress/videos/**/*.mp4'
          // archiveArtifacts allowEmptyArchive: true, artifacts: 'cypress/reports/html/**/*.*'
          archiveArtifacts allowEmptyArchive: true, artifacts: 'cypress/screenshots/**/*.png'

        }
      }

      
    }
    
  }
  post {
    always {
      echo "Send notifications for result: ${currentBuild.result}"
      // publish html
      publishHTML target: [
          allowMissing: false,
          alwaysLinkToLastBuild: true,
          keepAll: true,
          reportDir: 'cypress/reports/html/',
          reportFiles: 'full_report.html',
          reportName: 'E2EReport'
        ]
}
  }
}