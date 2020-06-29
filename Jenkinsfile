pipeline {
  agent any
    parameters {
        choice(name: 'Browser', choices: ['Electron', 'Chrome', 'Firefox'], description: '')
        booleanParam(name: 'executeTests', defaultValue: true, description: '')
    }
  stages {
    stage('build') {
      steps {
        sh 'npm install -g'
      }
    }

    stage('C1') {
      parallel {
        stage('C1') {
          steps {
            sh 'hostname'
            sh 'npx cypress run'
          }
        }

        stage('C2') {
          steps {
            sh 'hostname'
            sh 'npx cypress run'
          }
        }

      }
    }

  }
}