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
        expression {
          params.BUILDIMAGE == 'Yes'
        }

      }
      steps {
        sh 'docker build -f dockerfiles/Dockerfile.qa  -t brcm-cypress .'
      }
    }

    stage('Create reports folder') {
      steps {
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
          post {
            always {
              print env.MASTER_WORKSPACE
            }

          }
          steps {
            sh 'hostname && pwd && ls -l'
            sh 'npm run e2e:smoke'
          }
        }

        stage('Container2') {
          agent {
            docker {
              image 'brcm-cypress'
            }

          }
          steps {
            sh 'hostname && pwd && ls -l'
            sh 'npm run e2e:smoketwo'
          }
        }

      }
    }

  }
  environment {
    CI = 'true'
    MASTER_WORKSPACE = "${env.WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}"
  }
  post {
    always {
      echo 'Merging reports'
      echo "${MASTER_WORKSPACE}"
      sh "npx mochawesome-merge --reportDir ${MASTER_WORKSPACE}/reports > ${MASTER_WORKSPACE}/reports/full_report.json"
      echo 'Generating full report'
      sh "npx mochawesome-report-generator --reportDir ${MASTER_WORKSPACE}/reports ${MASTER_WORKSPACE}/reports/full_report.json"
    }

  }
  parameters {
    choice(name: 'BROWSER', choices: ['electron', 'chrome', 'firefox'], description: 'Browser')
    choice(name: 'BUILDIMAGE', choices: ['No', 'Yes'], description: 'Build image?')
  }
}