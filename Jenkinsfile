pipeline {
  agent {
    kubernetes {
              yaml """
                  apiVersion: v1
                  kind: Pod
                  metadata:
                    labels:
                      some-label: some-label-value
                  spec:
                    containers:
                    - name: busybox
                      image: busybox
                      command:
                      - cat
                      tty: true
                    securityContext:
                      runAsUser: 1000
                      fsGroup: 1000
              """
              defaultContainer 'busybox'
              workspaceVolume persistentVolumeClaimWorkspaceVolume(claimName: 'jenkins-workspace-zfs-local-ssd', readOnly: false)
          }
  }
  stages {
    stage('Build') {
      steps {
        echo 'Building docker image'
        sh "docker build -f dockerfiles/Dockerfile.qa -t brcm-cypress-${BRANCH_NAME} ."
        sh 'hostname && pwd && ls -l'
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
          // agent {
          //   docker {
          //     image "brcm-cypress-${BRANCH_NAME}"
          //   }

          // }
          // when {
          //   expression {
          //     params.BROWSER == 'electron' || params.BROWSER == 'all'
          //   }

          // }
          steps {
            echo 'Running test on Electron'
            sh 'hostname'
            // sh 'pwd && ls -l &&npm ci && ls -l'
            // catchError() {
            //   sh "cd /cypressbox && npm run e2e:${params.EXECUTIONTYPE}:electron"
            // }

            // echo currentBuild.result
            // sh "cp -rf /cypressbox/cypress/reports ${MASTER_WORKSPACE}"
          }
        }

        // stage('Chrome') {
        //   agent {
        //     docker {
        //       image "brcm-cypress-${BRANCH_NAME}"
        //     }

        //   }
        //   when {
        //     expression {
        //       params.BROWSER == 'chrome' || params.BROWSER == 'all'
        //     }

        //   }
        //   steps {
        //     echo 'Running test on Chrome'
        //     sh 'hostname'
        //     // sh 'pwd && ls -l &&npm ci && ls -l'
        //     catchError() {
        //       sh "cd /cypressbox && npm run e2e:${params.EXECUTIONTYPE}:chrome"
        //     }

        //     echo currentBuild.result
        //     sh "cp -rf /cypressbox/cypress/reports ${MASTER_WORKSPACE}"
        //   }
        // }

        // stage('Firefox') {
        //   agent {
        //     docker {
        //       image "brcm-cypress-${BRANCH_NAME}"
        //     }

        //   }
        //   when {
        //     expression {
        //       params.BROWSER == 'firefox'
        //     }

        //   }
        //   steps {
        //     echo 'Running test on Firefox'
        //     sh 'hostname'
        //     // sh 'pwd && ls -l &&npm ci && ls -l'
        //     catchError() {
        //       sh "cd /cypressbox && npm run e2e:${params.EXECUTIONTYPE}:firefox"
        //     }

        //     echo currentBuild.result
        //     sh "cp -rf /cypressbox/cypress/reports ${MASTER_WORKSPACE}"
        //   }
        // }

      }
    }

    // stage('Generating reports') {
    //   agent {
    //     docker {
    //       image "brcm-cypress-${BRANCH_NAME}"
    //     }

    //   }
    //   steps {
    //     echo 'Merging reports'
    //     sh "npx mochawesome-merge ${MASTER_WORKSPACE}/reports/mochawesome-report/*.json > ${MASTER_WORKSPACE}/reports/mochawesome-report/full_report.json"
    //     echo 'Generating full report'
    //     sh "npx mochawesome-report-generator --reportDir ${MASTER_WORKSPACE}/reports/mochawesome-report ${MASTER_WORKSPACE}/reports/mochawesome-report/full_report.json"
    //     archiveArtifacts(allowEmptyArchive: true, artifacts: "${MASTER_WORKSPACE}/reports/mochawesome-report/full_report.html")
    //     archiveArtifacts(allowEmptyArchive: true, artifacts: "${MASTER_WORKSPACE}/reports/mochawesome-report/assets/**")
    //     publishHTML([
    //                 allowMissing: false,
    //                 alwaysLinkToLastBuild: false,
    //                 keepAll: true,
    //                 reportDir: "${MASTER_WORKSPACE}/reports/mochawesome-report",
    //                 reportFiles: 'full_report.html',
    //                 reportName: 'E2E Report'
    //               ])
    //   }
    // }

  }
  environment {
    CI = 'true'
    MASTER_WORKSPACE = "${env.WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}"
  }
  parameters {
    choice(name: 'BROWSER', choices: ['electron', 'chrome', 'firefox', 'all'], description: 'Browser')
    choice(name: 'EXECUTIONTYPE', choices: ['smoke', 'all'], description: 'Tests execution selection')
  }
}