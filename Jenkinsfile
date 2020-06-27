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
        sh 'ls -l'
        script {
          def dockerfile = 'Dockerfile.qa'
          def customImage = docker.build("my-image:${env.BUILD_ID}", "-f ${dockerfile} ./dockerfiles")
          customImage.inside {
            sh 'pwd'
            sh 'ls -l'
            sh 'npm install'
          }
        }

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
            sh 'ls -l ./cypress'
            sh 'npx cypress run'
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