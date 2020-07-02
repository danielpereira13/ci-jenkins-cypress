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
      when {
        // Only say hello if a "greeting" is requested
        expression { params.BUILDIMAGE == 'Yes' }
      }
      steps {
        sh 'docker build -f dockerfiles/Dockerfile.qa  -t brcm-cypress .'
      }

      post {
            always {
              sh "mkdir -p ${WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}/reports"
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
            sh 'hostname'
            sh "cd /cypressdir && npm run e2e:smoke"
          }

          post {
            always {
              // archiveArtifacts artifacts: 'o*.json'
              print(env.MASTER_WORKSPACE)
              sleep 30000
              sh 'cd /cypressdir/cypress/reports/separate-reports; for file in *.json; do mv "$file" "${file_`date -Is`.json}"; done'
              sh "cp -avr /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports"
            }
          }
        }

        stage('Container2') {
          agent {
            docker {
              image 'brcm-cypress'
            }

          }
          
          steps {
            sh 'hostname'
            sh "cd /cypressdir && npm run e2e:smoketwo"
            print(env.MASTER_WORKSPACE)


          }

          post {
            always {
              // archiveArtifacts artifacts: 'o*.json'
              print(env.MASTER_WORKSPACE)
              sleep 30000
              sh 'cd /cypressdir/cypress/reports/separate-reports; for file in *.json; do mv "$file" "${file_`date -Is`.json}"; done'
              sh "cp -avr /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports"
              // sh "cp -avr /cypressdir/cypress/reports ${WORKSPACE%@*}/reports/${BUILD_TAG} && cp -avr /cypressdir/cypress/screenshots ${WORKSPACE%\@*}/screenshots/${BUILD_TAG} && cp -avr /cypressdir/cypress/videos ${WORKSPACE%\@*}/videos/${BUILD_TAG}"
              // sh "cp -avr /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER} && cp -avr /cypressdir/cypress/screenshots ${MASTER_WORKSPACE} && cp -avr /cypressdir/cypress/videos ${MASTER_WORKSPACE}"
            }
          }
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
    MASTER_WORKSPACE = "${env.WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}"
  }
  parameters {
    choice(name: 'BROWSER', choices: ['electron', 'chrome', 'firefox'], description: 'Browser')
    // choice(name: 'ENVIRONMENT', choices: ['QA', 'Dev', 'Prod'], description: 'Choose which environment to use')
    choice(name: 'BUILDIMAGE', choices: ['No', 'Yes'], description: 'Build image?')
  }
}

def get_first() {
    node('master') {
        return env.WORKSPACE
    }
}