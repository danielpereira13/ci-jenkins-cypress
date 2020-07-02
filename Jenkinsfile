pipeline {
  agent {
    node {
      label 'master'
    }

  }
  stages {
    stage('Build') {
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
    MASTER_WORKSPACE = '${env.WORKSPACE}/reports/${BUILD_TAG}/${params.BROWSER}'
  }
}