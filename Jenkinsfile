pipeline {
  agent {
    node {
      label 'master'
    }
  }
  parameters {
        choice(name: 'BROWSER', choices: ['Electron', 'Chrome', 'Firefox'], description: 'Browser')
        choice(name: 'ENVIRONMENT', choices: ['QA', 'Dev', 'Prod'], description: '"Choose which environment to use')

  }
  environment {
        CI = 'true'
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
            sh 'cd /cypressdir && npx cypress run'
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