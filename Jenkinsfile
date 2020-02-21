pipeline {
    agent {
        label 'my-builder'
    }
    environment {
        RG_NAME = "snprofile-django-rg"
        WEBAPP_NAME = "snprofile-django-app"
        DEVELOP_SLOT = "develop"
        FEATURE_SLOT = "feature"
    }
    stages {
        stage("Clean Workspace") {
            steps {
                cleanWs()
            }
        }
        stage("Checkout Source Control Manager") {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'feature/az']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'CleanBeforeCheckout']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Sebastian-Negoescu/snprofile-django.git'
                    ]]
                ])
            }
        }
        stage("Assure Items From Workspace") {
            steps {
                dir('./') {
                    sh 'pwd'
                    sh 'ls -la'
                }
            }
        }
        stage("Check that Environment Variables are in place") {
            steps {
                echo "Resource Group is: ${RG_NAME}"
                echo "Web App's name is: ${WEBAPP_NAME}"
                echo "My 2 slots are: ${FEATURE_SLOT} and ${DEVELOP_SLOT}"
                sh 'printenv'
            }
        }
        stage("Deploy to Azure Web App - FEATURE Slot") {
            steps {
                dir('./') {
                    azureWebAppPublish azureCredentialsId: 'AzDevOps', resourceGroup: "${RG_NAME}", appName: "${WEBAPP_NAME}", slotName: "${FEATURE_SLOT}", sourceDirectory: './', filePath: '**', targetDirectory: ''
                }
            }
        }
        stage("Confirm everything is okay") {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input "Approve/Deny further processing of the pipeline."
                }
            }
        }        
    }
}