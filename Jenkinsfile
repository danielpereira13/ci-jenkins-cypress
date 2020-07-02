pipeline {
  agent {
    node {
      label 'master'
    }

  }
  stages {
    stage('build') {
      when {
        // Only say hello if a "greeting" is requested
        expression { params.BUILDIMAGE == 'Yes' }
      }
      steps {
        sh 'docker build -f dockerfiles/Dockerfile.qa  -t brcm-cypress .'
      }
    }

    stage('Create reports directory on Jenkins'){
      steps{
        sh "mkdir -p ${WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}/reports"
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
            print(env.MASTER_WORKSPACE)
            catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
              sh "echo cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports  || true"
              sh "cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports  || true"
            }
          }

          // post {
          //   always {
          //     // archiveArtifacts artifacts: 'o*.json'
          //     print(env.MASTER_WORKSPACE)
          //     catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          //       sh "echo cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports  || true"
          //       sh "cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports  || true"
          //     }
          //   }
          // }
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
            catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
              sh "echo cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports  || true"
              sh "cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports  || true"
            }


          }

          // post {
          //   always {
          //     // archiveArtifacts artifacts: 'o*.json'
          //     print(env.MASTER_WORKSPACE)
          //     sh "echo cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports  || true"
          //     sh "cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports  || true"
          //     // sh "cp -avr /cypressdir/cypress/reports ${WORKSPACE%@*}/reports/${BUILD_TAG} && cp -avr /cypressdir/cypress/screenshots ${WORKSPACE%\@*}/screenshots/${BUILD_TAG} && cp -avr /cypressdir/cypress/videos ${WORKSPACE%\@*}/videos/${BUILD_TAG}"
          //     // sh "cp -avr /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER} && cp -avr /cypressdir/cypress/screenshots ${MASTER_WORKSPACE} && cp -avr /cypressdir/cypress/videos ${MASTER_WORKSPACE}"
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

  // post {
  //       always {
  //         echo 'Merging reports'
  //         sh "npx mochawesome-merge --reportDir ${MASTER_WORKSPACE}/reports/separate-reports > ${MASTER_WORKSPACE}/reports/full_report.json"
  //         echo 'Generating full report'
  //         sh "npx mochawesome-report-generator --reportDir ${MASTER_WORKSPACE}/reports/html ${MASTER_WORKSPACE}/reports/full_report.json"
  //       }
  // }
  environment {
    CI = 'true'
    MASTER_WORKSPACE = "${env.WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}"
  }
  parameters {
    choice(name: 'BROWSER', choices: ['electron', 'chrome', 'firefox'], description: 'Browser')
    // choice(name: 'ENVIRONMENT', choices: ['QA', 'Dev', 'Prod'], description: 'Choose which environment to use')
    choice(name: 'BUILDIMAGE', choices: ['No', 'Yes'], description: 'Build image?')
  }
}