/*
 * Declarative Pipeline
 */
pipeline {
    
    /*
     * Environment Variables
     */
    environment {
        PRODUCTION_DOCKERFILE = 'prod.Dockerfile'           // Production dockerfile name
        TEST_DOCKERFILE = 'test.Dockerfile'                 // Test dockerfile name
        
        PRODUCTION_REGISTRY = getProductionRegistry()       // Production registry name
        TEST_REGISTERY = getTestRegistry()                  // Test registry name

        PRODUCTION_IMAGE = null                             // Variable to hold production image
        TEST_IMAGE = null                                   // Variable to hold test image
    }
    
    /*
     * Define agent
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
        stage('Cloning Repository') {
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
                    PRODUCTION_IMAGE = docker.build(PRODUCTION_REGISTRY,  '-f ' + PRODUCTION_DOCKERFILE + ' .')
                    echo 'Successfully built production docker image'
                    
                    echo 'Building test docker image'
                    TEST_IMAGE = docker.build(TEST_REGISTERY,  '-f ' + TEST_DOCKERFILE + ' --build-arg PRODUCTION_IMAGE_TAG=%BUILD_NUMBER% .')
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
                    TEST_IMAGE.run('-d=false')
                    echo 'Successfully ran test docker image'
                }
            }
            post { 
                always { 
                    script {
                        getTestReports()

                        echo 'Removing test image'
                        if (isUnix()) {
                            sh 'docker container prune -f && docker rmi ' + TEST_REGISTERY
                        } else {
                            bat 'docker container prune -f && docker rmi ' + TEST_REGISTERY
                        }
                        TEST_IMAGE = null
                    }
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
        success {
            echo 'Success'
        }
        unstable {
            echo 'Unstable'
        }
        failure {
            echo 'Failed'
        }
        changed {
            echo 'Changed'
        }
    }
}

def getProductionRegistry() {
    if (isUnix()) {
        return 'adisakshya/express:$BUILD_NUMBER'
    } else {
        return 'adisakshya/express:%BUILD_NUMBER%'
    }
}

def getTestRegistry() {
    if (isUnix()) {
        return 'adisakshya/express-test:$BUILD_NUMBER'
    } else {
        return 'adisakshya/express-test:%BUILD_NUMBER%'
    }
}

def getTestReports() {
    def testContainerID = getTestContainerID()
    if (isUnix()) {
        sh 'docker cp ' + testContainerID + ':/usr/src/app/build .'
    } else {
        bat 'docker cp ' + testContainerID + ':/usr/src/app/build .'
    }
    junit 'build/reports/*.xml'
}

def getTestContainerID() {
    if (isUnix()) {
        return getCommandOutput('docker ps -q --filter=ancestor=adisakshya/express-test:$BUILD_NUMBER -a')
    } else {
        return getCommandOutput('docker ps -q --filter=ancestor=adisakshya/express-test:%BUILD_NUMBER% -a')
    }
}

def getCommandOutput(cmd) {
    if (isUnix()){
         return sh(returnStdout:true , script: '#!/bin/sh -e\n' + cmd).trim()
     } else{
       stdout = bat(returnStdout:true , script: cmd).trim()
       result = stdout.readLines().drop(1).join(" ")       
       return result
    } 
}