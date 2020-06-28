pipeline {
  agent {
    docker {
      image 'cypress/browsers:node13.6.0-chrome80-ff72'
    }

  }
  stages {
    stage('build') {
      steps {
        sh 'npm install'
      }
    }

    stage('C1') {
      parallel {
        stage('C1') {
          steps {
            sh 'npm run cy:run'
          }
        }

        stage('C2') {
          steps {
            sh 'npm run cy:run'
          }
        }

      }
    }

  }
}