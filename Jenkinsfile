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
        sh 'echo docker build -f dockerfiles/Dockerfile.qa  -t brcm-cypress .'
        sh 'pwd'
        sh 'ls -l'
        sh "mkdir -p ${WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}"
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
            sh 'hostname'
            // sh 'pwd && ls -l '
            // sh 'cd /cypressdir/cypress && ls -l'
            // sh "cd /cypressdir && npx cypress run"
            // sh 'echo "testing,...." > ./output.json'
            // sh 'pwd && ls -l'
          }

          post {
            always {
              // archiveArtifacts artifacts: 'o*.json'
              // sleep 3000
              print(env.first_path)
              // sh "cp -avr /cypressdir/cypress/reports ${WORKSPACE%@*}/reports"
              // sh "cp -avr /cypressdir/cypress/reports ${WORKSPACE%@*}/reports/${BUILD_TAG} && cp -avr /cypressdir/cypress/screenshots ${WORKSPACE%\@*}/screenshots/${BUILD_TAG} && cp -avr /cypressdir/cypress/videos ${WORKSPACE%\@*}/videos/${BUILD_TAG}"
              // sh "cp -avr /cypressdir/cypress/reports ./${BUILD_TAG} && cp -avr /cypressdir/cypress/screenshots ./${BUILD_TAG} && cp -avr /cypressdir/cypress/videos ./${BUILD_TAG}"
              // sleep 300
            }
          }
        }

        // stage('Container2') {
        //   agent {
        //     docker {
        //       image 'brcm-cypress'
        //     }

        //   }
          
        //   steps {
        //     sh 'hostname'
        //     // sh 'pwd && ls -l '
        //     // sh 'cd /cypressdir/cypress && ls -l'
        //     sh "cd /cypressdir && npx cypress run --browser ${params.BROWSER}"
        //   }

        //   post {
        //     always {
        //       sh "mkdir -p ${WORKSPACE}/${BUILD_TAG}/${params.BROWSER}"
        //       // TODO: replace cd to a single command
        //       sh "cd ${BUILD_TAG} && cd ${params.BROWSER} && cp -avr /cypressdir/cypress/reports . && cp -avr /cypressdir/cypress/screenshots . && cp -avr /cypressdir/cypress/videos ."
        //     }
        //   }
        // }

        stage('Container2') {
          agent {
            docker {
              image 'brcm-cypress'
            }

          }
          
          steps {
            sh 'hostname'
            // sh 'pwd && ls -l '
            // sh 'cd /cypressdir/cypress && ls -l'
            // sh "cd /cypressdir && npx cypress run --browser ${params.BROWSER}"
            // sh 'echo "testing,...." > ./output2.json'
            // sh 'pwd && ls -l'
            print(env.first_path)


          }

          // post {
          //   always {
          //     // archiveArtifacts artifacts: 'o*.json'
          //     // sleep 3000
          //     // sh "cp -avr /cypressdir/cypress/reports ./${BUILD_TAG} && cp -avr /cypressdir/cypress/screenshots ./${BUILD_TAG} && cp -avr /cypressdir/cypress/videos ./${BUILD_TAG} "
          //     // sh "cp -avr /cypressdir/cypress/reports ./${BUILD_TAG} && cp -avr /cypressdir/cypress/screenshots ./${BUILD_TAG} && cp -avr /cypressdir/cypress/videos ./${BUILD_TAG}"
          //     // sleep 300
          //   // sh "cp -avr /cypressdir/cypress/reports ${WORKSPACE%@*}/reports/${BUILD_TAG} && cp -avr /cypressdir/cypress/screenshots ${WORKSPACE%@*}/screenshots/${BUILD_TAG} && cp -avr /cypressdir/cypress/videos ${WORKSPACE%@*}/videos/${BUILD_TAG}"

          //   }
          // }
        }

      }
    }

    stage('Generate report') {
      agent {
        node {
          label 'master'
        }

      }
      steps {
        echo 'Merging reports'
        sh "npx mochawesome-merge --reportDir ./${BUILD_TAG}/reports/separate-reports > ./${BUILD_TAG}/reports/full_report.json"
        echo 'Generating full report'
        sh "npx mochawesome-report-generator --reportDir ./${BUILD_TAG}/reports/html ./${BUILD_TAG}/reports/full_report.json"
      }
    }

  }
  environment {
    CI = 'true'
    first_path = get_first()
  }
  parameters {
    choice(name: 'BROWSER', choices: ['electron', 'chrome', 'firefox'], description: 'Browser')
    choice(name: 'ENVIRONMENT', choices: ['QA', 'Dev', 'Prod'], description: '"Choose which environment to use')
  }
}

def get_first() {
    node('master') {
        return env.WORKSPACE
    }
}