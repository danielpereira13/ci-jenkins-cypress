pipeline {

  environment {
    CI = 'true'
    MASTER_WORKSPACE = "${env.WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}"
  }

  parameters {
    choice(name: 'BROWSER', choices: ['electron', 'chrome', 'firefox'], description: 'Browser')
    // choice(name: 'ENVIRONMENT', choices: ['QA', 'Dev', 'Prod'], description: 'Choose which environment to use')
    choice(name: 'BUILDIMAGE', choices: ['No', 'Yes'], description: 'Build image?')
  }

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

      // post {
      //       always {
      //         sh "mkdir -p ${WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}/reports"
      //       }
      // }
    }

    stage('Create reports folder'){
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
          }

          post {
            always {
              // archiveArtifacts artifacts: 'o*.json'
              print(env.MASTER_WORKSPACE)
              // sh "cp -avr /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports"
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
        //     sh "cd /cypressdir && npm run e2e:smoketwo"
        //     print(env.MASTER_WORKSPACE)
        //   }

        //   post {
        //     always {
        //       // archiveArtifacts artifacts: 'o*.json'
        //       print(env.MASTER_WORKSPACE)
        //       // sh "cp -avr /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports"
        //       // sh "cp -avr /cypressdir/cypress/reports ${WORKSPACE%@*}/reports/${BUILD_TAG} && cp -avr /cypressdir/cypress/screenshots ${WORKSPACE%\@*}/screenshots/${BUILD_TAG} && cp -avr /cypressdir/cypress/videos ${WORKSPACE%\@*}/videos/${BUILD_TAG}"
        //       // sh "cp -avr /cypressdir/cypress/reports ${MASTER_WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER} && cp -avr /cypressdir/cypress/screenshots ${MASTER_WORKSPACE} && cp -avr /cypressdir/cypress/videos ${MASTER_WORKSPACE}"
        //     }
        //   }
        // }

      }
    }
 }

  post{
    always{
      echo 'Merging reports'
      echo "${MASTER_WORKSPACE}"
      sh "npx mochawesome-merge --reportDir ${MASTER_WORKSPACE}/reports > ${MASTER_WORKSPACE}/reports/full_report.json"
      echo 'Generating full report'
      sh "npx mochawesome-report-generator --reportDir ${MASTER_WORKSPACE}/reports ${MASTER_WORKSPACE}/reports/full_report.json"
    }
  }
} //pipeline end