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
         bat 'npm install'
       }
    }
    stage('Test') {
      steps {
        bat 'npm test'
      }
    }
  }
}