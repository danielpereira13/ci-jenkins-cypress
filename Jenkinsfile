pipeline {
  agent {
    node {
      label 'master'
    }

  }
  stages {
    stage('Build') {
      when {
        expression {
          params.BUILDIMAGE == 'Yes'
        }

      }
      steps {
        echo 'Building docker image'
        sh 'docker build -f dockerfiles/Dockerfile.qa  -t brcm-cypress .'
      }
    }

    stage('Create reports directory on Jenkins') {
      steps {
        sh "mkdir -p ${WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}/reports"
      }
    }

    stage('Test') {
      parallel {
        stage('Container 1') {
          agent {
            docker {
              image 'brcm-cypress'
            }

          }
          steps {
            echo 'Hello conatiner 1'
          }
        }

        stage('Container 2') {
          agent {
            docker {
              image 'brcm-cypress'
            }

          }
          steps {
            echo 'hello container 2'
          }
        }

        stage('Container 3') {
          agent {
            docker {
              image 'brcm-cypress'
            }

          }
          steps {
            echo 'Hello container 3'
          }
        }

      }
    }

    stage('Deploy') {
      steps {
        echo 'Deploying....'
      }
    }

  }
  environment {
    CI = 'true'
    MASTER_WORKSPACE = "${env.WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}"
  }
  parameters {
    choice(name: 'BROWSER', choices: ['electron', 'chrome', 'firefox'], description: 'Browser')
    choice(name: 'BUILDIMAGE', choices: ['No', 'Yes'], description: 'Build image?')
  }
}