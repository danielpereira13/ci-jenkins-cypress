pipeline {
  agent {
    node {
      label 'master'
    }

  }
  stages {
    stage('Build') {
      when {
        // Only say hello if a "greeting" is requested
        expression { params.BUILDIMAGE == 'Yes' }
      }
      steps {
        echo 'Building docker image'
        sh 'docker build -f dockerfiles/Dockerfile.qa  -t brcm-cypress .'
      }
    }

    stage('Test') {
      agent {
        docker {
          image 'brcm-cypress'
        }

      }
      steps {
        echo 'Testing..'
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
    // choice(name: 'ENVIRONMENT', choices: ['QA', 'Dev', 'Prod'], description: 'Choose which environment to use')
    choice(name: 'BUILDIMAGE', choices: ['No', 'Yes'], description: 'Build image?')
  }
}