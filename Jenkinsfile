pipeline {
  agent {
    docker {
      image 'cy/base-image:latest'
    }

  }
  stages {
    stage('build') {
      steps {
        echo "Running build ${env.BUILD_ID} on ${env.JENKINS_URL}"
        sh 'hostname'
        sh 'npm install'
      }
    }

    stage('Test - Electron') {
      agent {
        dockerfile {
          filename 'Dockerfile'
        }

      }
      post {
        always {
          sh 'npm run after:tests'
        }

        failure {
          archiveArtifacts(allowEmptyArchive: true, artifacts: 'cypress/videos/**/*.mp4')
          archiveArtifacts(allowEmptyArchive: true, artifacts: 'cypress/screenshots/**/*.png')
        }

      }
      steps {
        sh 'npm run cypress -v'
      }
    }

  }
  post {
    always {
      echo "Send notifications for result: ${currentBuild.result}"
      publishHTML(allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: 'cypress/reports/html/', reportFiles: 'full_report.html', reportName: 'E2EReport')
    }

  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '3'))
  }
}