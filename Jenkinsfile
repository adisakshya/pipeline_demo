/*
 * Declarative Pipeline
 */
pipeline {
    
    /*
     * Environment Variables
     */
    environment {
        dockerfileProduction = 'prod.Dockerfile'        // Production dockerfile name
        dockerfileTest = 'test.Dockerfile'              // Test dockerfile name
        
        registryProduction = 'adisakshya/express'       // Production registry name
        registryTest = 'adisakshya/express-test'        // Test registry name

        test_container = null                           // Variable to hold test image container
        production = null                               // Variable to hold production image
        test = null                                     // Variable to hold test image
    }
    
    /*
     * Auto select agent
     */
    agent any
    
    /*
     * Use docker tool
     */
    tools {
        'org.jenkinsci.plugins.docker.commons.tools.DockerTool' 'Docker'
    }
    
    /*
     * Stages in build
     */
    stages {

        /*
         * Clone git repository
         */
        stage('Cloning Git') {
            agent any
            steps {
                echo 'Cloning git repository'
                git 'https://github.com/adisakshya/pipeline_demo'
                echo 'Successfully cloned git repository'
            }
        }
        
        /*
         * Build production and test docker images
         */
        stage('Build') {
            agent any
            steps {
                script {
                    echo 'Building production docker image'
                    production = docker.build(registryProduction,  '-f ' + dockerfileProduction + ' .')
                    echo 'Successfully built production docker image'
                    
                    echo 'Building test docker image'
                    test = docker.build(registryTest,  '-f ' + dockerfileTest + ' .')
                    echo 'Successfully built test docker image'
                }
            }
        }
        
        /*
         * Run test docker image, to execute tests
         * and after completion remove the container
         * running the test docker image
         */
        stage('Test') {
            steps {
                script {
                    echo 'Running test docker image'
                    test_container = test.run('-d=false --rm')
                    echo 'Successfully ran test docker image and removed test container'

                    echo 'Removing test image'
                    if (isUnix()) {
                        sh 'docker rmi ${registryTest}'
                    } else {
                        bat 'docker rmi %registryTest%'
                    }
                    test = null
                    test_container = null
                }
            }
        }
    }
    
    post {
        always {
            echo 'Removing all dangling images'
            script {
                if (isUnix()) {
                    sh 'docker image prune -f'
                } else {
                    bat 'docker image prune -f'
                }
            }
        }
        failure {
            echo 'Failed'
        }
        changed {
            echo 'Changed'
        }
        success {
            echo 'Success'
        }
    }
}