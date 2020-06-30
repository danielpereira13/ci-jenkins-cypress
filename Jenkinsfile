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

    stage('Testing') {
      parallel {
        stage('Container1') {
          agent {
            docker {
              image 'brcm-cypress'
            }

          }
          post {
            always {
              sh 'cd /cypressdir/cypress && ls -l'
              sh 'pwd && ls -l'
              sh "cd ${WORKSPACE} && mkdir ./${BUILD_TAG}/${params.BROWSER}"
              sh "ls -l ${WORKSPACE}/${BUILD_TAG}/${params.BROWSER}"
            }

          }
          steps {
            sh 'hostname'
            sh 'pwd && ls -l '
            sh 'cd /cypressdir/cypress && ls -l'
            sh "cd /cypressdir && npx cypress run --browser ${params.BROWSER}"
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
            sh 'echo ${WORKSPACE}'
            sh 'ls -l ${WORKSPACE}/cypress'
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
  environment {
    CI = 'true'
  }
  parameters {
    choice(name: 'BROWSER', choices: ['electron', 'chrome', 'firefox'], description: 'Browser')
    choice(name: 'ENVIRONMENT', choices: ['QA', 'Dev', 'Prod'], description: '"Choose which environment to use')
  }
}