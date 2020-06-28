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
        node {
          label 'master'
        }

      }
      steps {
        echo 'gg'
        sh 'hostname'
        sh 'pwd'
        sh 'ls -l ${WORKSPACE}/dockerfiles/qa'
        script {
          def testImage = docker.build("test-image", "${WORKSPACE}/dockerfiles/qa")
          testImage.inside {
            sh 'hostname'
            sh 'pwd'
            sh 'ls -l'
            sh 'cat > sample.txt'
            sh 'npm install -g'
            sh 'ls -l'
          }
        }

      }
    }

    stage('Testing') {
      parallel {
        stage('Container1') {
          agent {
            docker {
              image 'test-image'
            }

          }
          steps {
            echo 'From container 1'
            sh 'hostname'
            sh 'pwd'
            sh 'ls -l'
            sh 'pwd'
            sh 'ls -l'
            sh 'npx cypress run --spec "cypress/integration/examples/actions.spec.js"'
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
            sh 'npx cypress run --spec "cypress/integration/examples/actionstwo.spec.js"'
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