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

    stage('install dependencies') {
      agent {
        docker {
          image 'brcm-cypress'
        }

      }
      steps {
        echo 'gg'
        sh 'hostname'
        sh 'pwd'
        sh 'ls -l'
      }
    }

    stage('Testing') {
      parallel {
        stage('Container1') {
          agent {
            docker {
              image 'brcm-cypress'
            }

          }
          steps {
            echo 'From container 1'
            sh 'hostname'
            sh 'pwd'
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
          }
        }

      }
    }

    stage('end') {
      agent {
        node {
          label 'master'
        }

      }
      steps {
        echo 'ending'
      }
    }

  }
}