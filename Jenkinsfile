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
}