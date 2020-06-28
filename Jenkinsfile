pipeline {
  agent {
    docker {
      image 'cypress/included:4.9.0'
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