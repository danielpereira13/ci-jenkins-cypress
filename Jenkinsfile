pipeline {
  agent {
    node {
      label 'master'
    }

  }
  stages {
    stage('Example') {
      steps {
        echo 'Hello World'
        script {
          def browsers = ['chrome', 'firefox']
          for (int i = 0; i < browsers.size(); ++i) {
            echo "Testing the ${browsers[i]} browser"
          }
        }

      }
    }

    stage('build') {
      steps {
        sh 'hostname'
        sh 'ls -l ./cypress'
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
        sh 'npm root -g'
        sh 'npm list -g'
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
            sh 'hostname'
            sh 'pwd'
            sh 'ls -l'
            sh 'npm list -g'
            sleep 300
            sh '/cypressdir/node_modules/cypress/bin/cypress run'
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