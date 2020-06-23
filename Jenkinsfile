// Example Jenkins pipeline with Cypress end-to-end tests running in parallel on 2 workers
// Pipeline syntax from https://jenkins.io/doc/book/pipeline/

// Setup:
//  before starting Jenkins, I have created several volumes to cache
//  Jenkins configuration, NPM modules and Cypress binary

// docker volume create jenkins-data
// docker volume create npm-cache
// docker volume create cypress-cache

// Start Jenkins command line by line:
//  - run as "root" user (insecure, contact your admin to configure user and groups!)
//  - run Docker in disconnected mode
//  - name running container "blue-ocean"
//  - map port 8080 with Jenkins UI
//  - map volumes for Jenkins data, NPM and Cypress caches
//  - pass Docker socket which allows Jenkins to start worker containers
//  - download and execute the latest BlueOcean Docker image

// docker run \
//   -u root \
//   -d \
//   --name blue-ocean \
//   -p 8080:8080 \
//   -v jenkins-data:/var/jenkins_home \
//   -v npm-cache:/root/.npm \
//   -v cypress-cache:/root/.cache \
//   -v /var/run/docker.sock:/var/run/docker.sock \
//   jenkinsci/blueocean:latest

// If you start for the very first time, inspect the logs from the running container
// to see Administrator password - you will need it to configure Jenkins via localhost:8080 UI
//    docker logs blue-ocean

pipeline {
  agent {
    // this image provides everything needed to run Cypress
    docker {
      image 'cypress/base:10'
      // image 'cypress/included:4.8.0'
    }
  }

  stages {
    // first stage installs node dependencies and Cypress binary
    stage('build') {
      steps {
        // there a few default environment variables on Jenkins
        // on local Jenkins machine (assuming port 8080) see
        // http://localhost:8080/pipeline-syntax/globals#env
        echo "Running build ${env.BUILD_ID} on ${env.JENKINS_URL}"
        sh 'hostname'
        sh 'npm install'
        //sh 'npm run cy:verify'
      }
    }

    // stage('Cypress Info') {
    //   steps {
    //     sh "npm run cy:info"
    //   }
    // }

    stage('Smoke - Electron') {
      steps {
        //sh "npm run e2e:smoke"
        sh 'npm run pretest'
        sh 'npm run testx'
        
      }
    }

    // // post {
    // //     always {
    // //         // archiveArtifacts artifacts: 'cypress/videos/examples/*.mp4'
    // //         archiveArtifacts artifacts: 'build/libs/**/*.jar', fingerprint: true
    // //         junit 'build/reports/**/*.xml'
    // // }

    // stage('Run test Electron----') {
    //   steps {
    //     sh "npm run e2e"
    //   }
    // }

  }

  post {
    // shutdown the server running in the background
    always {
      echo '\n\n\n=================== Merging reports ==================='
      sh 'ls -l cypress/results/json/'
      sh 'npm run merge:reports'
      sh 'npm run generate:report'
      // sh 'npx mochawesome-merge --reportDir ${env.JENKINS_URL}/cypress/results/json > ${env.JENKINS_URL}/cypress/results/mochawesome-bundle.json'
      // echo '\n\n\n=================== Generating HTML report ==================='
      // sh 'npm run report:generate'
      // echo '\n\n\n=================== Copying screenshots to results folder ==================='
      // sh 'npm run report:generate'
      publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'var/jenkins_home/workspace/cypress_electron/mochawesome-report/cypress/results', reportFiles: 'index.html', reportName: 'HTML Report3', reportTitles: ''])
    }
  }
}
