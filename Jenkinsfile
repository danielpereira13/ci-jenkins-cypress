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
        sh 'docker -v'
      }
    }

    stage('Testing') {
      steps {
        sh 'hostname'
      }
    }

  }
}