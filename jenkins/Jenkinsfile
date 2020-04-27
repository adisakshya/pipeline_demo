/*
 * Declarative Pipeline
 */
pipeline {
    
    /*
     * Define agent
     */
    agent any
    
    /*
     * Use docker tool
     */
    tools {
        'org.jenkinsci.plugins.docker.commons.tools.DockerTool' 'docker'
    }
    
    /*
     * Environment Variables
     */
    environment {
        VERSION = null                      // Version of service

        PRODUCTION_DOCKERFILE = null        // Production dockerfile name
        PRODUCTION_REGISTRY = null          // Production registry name
        PRODUCTION_IMAGE = null             // Variable to hold production image
        
        TEST_DOCKERFILE = null              // Test dockerfile name
        TEST_REGISTERY = null               // Test registry name
        TEST_IMAGE = null                   // Variable to hold test image
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
            tools {
                git 'Default'
            }
            steps {
                echo 'Cloning git repository'
                script {
                    git 'https://github.com/adisakshya/pipeline_demo'
                }
            }
            post { 
                always {
                    script {
                        executeCommand('dir')
                    }
                }
                success { 
                    echo 'Successfully cloned git repository'
                }
                failure {
                    echo 'Failed to clone git repository'
                }
            }
        }
        
        /*
         * Identify version of service
         */
        stage('Versioning') {
            agent any
            tools {
                nodejs 'node'
            }
            steps {
                echo 'Getting version information'
                script {
                    VERSION = getCommandOutput('node -p -e "require(\'./package.json\').version"')
                }
            }
            post { 
                always { 
                    script {
                        if (VERSION == 'undefined' || !VERSION || !(VERSION instanceof String)) {
                            currentBuild.result = 'FAILED'
                            error('Failed to identify version information')
                        } else {
                            echo 'Identified VERSION: ' + VERSION
                        }
                    }
                }
            }
        }

        /*
         * Set environment variables
         */
        stage('Environement Setup') {
            agent any
            steps {
                echo 'Setting environment variables'
                script {
                    PRODUCTION_DOCKERFILE = 'prod.Dockerfile'
                    PRODUCTION_REGISTRY = getProductionRegistry(VERSION)
                    
                    TEST_DOCKERFILE = 'test.Dockerfile'
                    TEST_REGISTRY = getTestRegistry(VERSION)
                }
            }
            post { 
                always { 
                    script {
                        if (!PRODUCTION_DOCKERFILE || !PRODUCTION_REGISTRY || !TEST_DOCKERFILE || !TEST_REGISTRY) {
                            currentBuild.result = 'FAILED'
                            error('Failed to set environment variables')
                        } else {
                            echo 'PRODUCTION_DOCKERFILE: ' + PRODUCTION_DOCKERFILE
                            echo 'PRODUCTION_REGISTRY: ' + PRODUCTION_REGISTRY
                            echo 'TEST_DOCKERFILE: ' + TEST_DOCKERFILE
                            echo 'TEST_REGISTRY: ' + TEST_REGISTRY
                        }
                    }
                }
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
                    TEST_IMAGE = docker.build(TEST_REGISTRY,  '-f ' + TEST_DOCKERFILE + ' --build-arg PRODUCTION_IMAGE_TAG=' + VERSION + ' .')
                    echo 'Successfully built test docker image'
                }
            }
        }
        
        /*
         * Run test docker image, to execute tests
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
                        getTestReports(VERSION)
                        echo 'Removing test image'
                        executeCommand('docker container prune -f && docker rmi ' + TEST_REGISTRY)
                        TEST_IMAGE = null
                    }
                }
            }
        }

        /*
         * Deploy to development
         */
        stage('Deploy to development') {
            when {
                branch 'development'  
            }
            steps {
                script {
                    echo 'Ready for deploying to development'
                    input message: 'Satisfied with test results? Deploy to development? (Click "Proceed" to continue)'
                    deployToDevelopment(PRODUCTION_REGISTRY)
                }
            }
            post { 
                always { 
                    script {
                        echo 'Removing production docker image'
                        executeCommand('docker container prune -f && docker rmi ' + PRODUCTION_REGISTRY + ' -f')
                        echo 'Removing development docker image'
                        executeCommand('docker container prune -f && docker rmi ' + PRODUCTION_REGISTRY + '-dev -f')
                        PRODUCTION_IMAGE = null
                    }
                }
            }
        }

        /*
         * Deploy to production
         */
        stage('Deploy to production') {
            when {
                branch 'production'  
            }
            steps {
                script {
                    echo 'Ready for deploying to production'
                    input message: 'Satisfied with test results? Deploy to production? (Click "Proceed" to continue)'
                    deployToProduction(PRODUCTION_REGISTRY)
                }
            }
            post { 
                always { 
                    script {
                        echo 'Removing production image'
                        executeCommand('docker container prune -f && docker rmi ' + PRODUCTION_REGISTRY + ' -f')
                        PRODUCTION_IMAGE = null
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo 'Removing all dangling images'
                executeCommand('docker image prune -f')
                echo 'Removing all created/tagged images'
                def DEVELOPMENT_IMAGE_ID = getCommandOutput('docker images -q ' + PRODUCTION_REGISTRY + '-dev')
                if(DEVELOPMENT_IMAGE_ID && (DEVELOPMENT_IMAGE_ID instanceof String)) {
                    executeCommand('docker container prune -f && docker rmi ' + PRODUCTION_REGISTRY + '-dev -f')
                }
                if (PRODUCTION_IMAGE) {
                    executeCommand('docker container prune -f && docker rmi ' + PRODUCTION_REGISTRY + ' -f')
                    PRODUCTION_IMAGE = null
                }
                if (TEST_IMAGE) {
                    executeCommand('docker container prune -f && docker rmi ' + TEST_REGISTRY + ' -f')
                    TEST_IMAGE = null
                }
                cleanWs()
            }
        }
        aborted {
            echo 'Aborted'
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

/*
 * Execute command
 */
def executeCommand(String command) {
    if (isUnix()) {
        sh command
    } else {
        bat command
    }
}

/*
 * Return production registry name
 */
def getProductionRegistry(String VERSION) {
    if (isUnix()) {
        return 'adisakshya/express:' + VERSION
    } else {
        return 'adisakshya/express:' + VERSION
    }
}

/*
 * Return test registry name
 */
def getTestRegistry(String VERSION) {
    if (isUnix()) {
        return 'adisakshya/express-test:' + VERSION
    } else {
        return 'adisakshya/express-test:' + VERSION
    }
}

/*
 * Get JUnit test reports
 */
def getTestReports(String VERSION) {
    def testContainerID = getTestContainerID(VERSION)
    executeCommand('docker cp ' + testContainerID + ':/usr/src/app/build .')
    junit 'build/reports/*.xml'
}

/*
 * Return test container ID
 */
def getTestContainerID(String VERSION) {
    if (isUnix()) {
        return getCommandOutput('docker ps -q --filter=ancestor=adisakshya/express-test:' + VERSION + ' -a')
    } else {
        return getCommandOutput('docker ps -q --filter=ancestor=adisakshya/express-test:' + VERSION + ' -a')
    }
}

/*
 * Deploy to development
 */
def deployToDevelopment(String PRODUCTION_REGISTRY) {
    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'p', usernameVariable: 'u')]) {
        executeCommand('docker login -u ' + u + ' -p ' + p + ' https://index.docker.io/v1/')
        executeCommand('docker tag ' + PRODUCTION_REGISTRY + ' ' + PRODUCTION_REGISTRY + '-dev')
        executeCommand('docker push ' + PRODUCTION_REGISTRY + '-dev')
    }
}

/*
 * Deploy to production
 */
def deployToProduction(String PRODUCTION_REGISTRY) {
    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'p', usernameVariable: 'u')]) {
        executeCommand('docker login -u ' + u + ' -p ' + p + ' https://index.docker.io/v1/')
        executeCommand('docker push ' + PRODUCTION_REGISTRY)
    }
}

/*
 * Get a command output
 */
def getCommandOutput(String COMMAND) {
    if (isUnix()){
         return sh(returnStdout:true , script: '#!/bin/sh -e\n' + COMMAND).trim()
     } else{
       stdout = bat(returnStdout:true , script: COMMAND).trim()
       result = stdout.readLines().drop(1).join(" ")       
       return result
    } 
}