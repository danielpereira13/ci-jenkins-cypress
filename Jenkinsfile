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
        stage('Electron') {
          when {
            // Only say hello if a "greeting" is requested
            expression { params.BROWSER == 'electron' || params.BROWSER == 'all' }
          }
          agent {
            docker {
              image 'brcm-cypress'
            }
          }
          steps {
            echo "Running test on Electron"
            sh 'hostname'
            catchError {
              // sh "cd /cypressdir && npm run e2e:smoke"
              sh "cd /cypressdir && npm run e2e:${params.EXECUTIONTYPE}"
            }
            echo currentBuild.result
            sh "cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}"
          }
        }

        stage('Chrome') {
          when {
            // Only say hello if a "greeting" is requested
            expression { params.BROWSER == 'chrome' || params.BROWSER == 'all' }
          }
          agent {
            docker {
              image 'brcm-cypress'
            }
          }
          steps {
            echo "Running test on Chrome"
            sh 'hostname'
            catchError {
              // sh "cd /cypressdir && npm run e2e:smoke"
              sh "cd /cypressdir && npm run e2e:chrome:${params.EXECUTIONTYPE}"
            }
            echo currentBuild.result
            sh "cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}"
          }
        }

        stage('Firefox') {
          when {
            // Only say hello if a "greeting" is requested
            expression { params.BROWSER == 'firefox' || params.BROWSER == 'all' }
          }
          agent {
            docker {
              image 'brcm-cypress'
            }
          }
          steps {
            echo "Running test on Firefox"
            sh 'hostname'
            catchError {
              // sh "cd /cypressdir && npm run e2e:smoke"
              sh "cd /cypressdir && npm run e2e:firefox:${params.EXECUTIONTYPE}"
            }
            echo currentBuild.result
            sh "cp -rf /cypressdir/cypress/reports ${MASTER_WORKSPACE}"
          }
        }

      }
    }

    stage('Generating reports') {
      agent {
        docker {
          image 'brcm-cypress'
        }
      }
      steps {
        echo 'Merging reports'
        sh "npx mochawesome-merge ${MASTER_WORKSPACE}/reports/mochawesome-report/*.json > ${MASTER_WORKSPACE}/reports/mochawesome-report/full_report.json"
        echo 'Generating full report'
        sh "npx mochawesome-report-generator --reportDir ${MASTER_WORKSPACE}/reports/mochawesome-report ${MASTER_WORKSPACE}/reports/mochawesome-report/full_report.json"

        archiveArtifacts allowEmptyArchive: true, artifacts: "${MASTER_WORKSPACE}/reports/mochawesome-report/full_report.html"
        archiveArtifacts allowEmptyArchive: true, artifacts: "${MASTER_WORKSPACE}/reports/mochawesome-report/assets/**"
        // publish html
        publishHTML target: [
          allowMissing: false,
          alwaysLinkToLastBuild: false,
          keepAll: true,
          reportDir: "${MASTER_WORKSPACE}/reports/mochawesome-report",
          reportFiles: 'full_report.html',
          reportName: 'E2E Report'
        ]
      }

    }

  }
  environment {
    CI = 'true'
    MASTER_WORKSPACE = "${env.WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}"
  }
  parameters {
    choice(name: 'BROWSER', choices: ['electron', 'chrome', 'firefox', 'all'], description: 'Browser')
    choice(name: 'BUILDIMAGE', choices: ['No', 'Yes'], description: 'Build image?')
    choice(name: 'EXECUTIONTYPE', choices: ['smoke', 'all'], description: 'Tests execution selection')
  }
}