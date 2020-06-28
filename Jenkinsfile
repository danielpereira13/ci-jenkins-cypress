pipeline {
  agent {
    node {
      label 'master'
    }

  }
  stages {
    stage('Testing') {
      parallel {
        stage('Container1') {
          agent {
            docker {
              image 'cypress/included:4.9.0'
            }

          }
          steps {
            echo 'From container 1'
            sh 'hostname'
            sh 'pwd'
            sh 'ls -l'
            sh 'pwd'
            sh 'npm run cy:run'
          }
        }

        stage('Container2') {
          agent {
            docker {
              image 'brcm-cypress'
            }

          }
          steps {
            echo 'From container 2'
            sh 'hostname'
            sh 'pwd'
            sh 'ls -l'
            sh 'npx cypress -v'
          }
        }

      }
    }

  }
}