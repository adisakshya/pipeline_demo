pipeline {
  agent any
  tools {nodejs "node" }
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/adisakshya/pipeline_demo'
      }
    }
    stage('Build') {
       steps {
         sh 'npm install --suffix app/'
       }
    }
    stage('Test') {
      steps {
        sh 'npm test --suffix app/'
      }
    }
  }
}