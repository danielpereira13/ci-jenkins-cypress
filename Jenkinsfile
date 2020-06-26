pipeline {
  agent {
    node {
      label 'master'
    }

  }
  stages {
    stage('build') {
      steps {
        echo "Running build ${env.BUILD_ID} on ${env.JENKINS_URL}"
        sh 'hostname'
        sh 'ls -l'
      }
    }

    stage('Testing') {
      steps {
        sh 'hostname'
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