pipeline {
  agent {
    node {
      label 'master'
    }

  }
  stages {
    stage('build') {
      steps {
        sh 'hostname'
        sh 'ls -l'
        sh 'docker build -f dockerfiles/Dockerfile.qa  -t brcm-cypress .'
      }
    }

    stage('Testing') {
      agent {
        docker {
          image 'brcm-cypress'
        }

      }
      steps {
        sh 'hostname'
      }
    }

  }
}