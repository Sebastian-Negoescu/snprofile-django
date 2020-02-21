pipeline {
    agent {
        label 'my-builder'
    }
    environment {
        RG_NAME = "snprofile-django-rg"
        WEBAPP_NAME = "snprofile-django"
        DEVELOP_SLOT = "slot"
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
        stage("Deploy to Azure Web App - FEATURE Slot") {
            steps {
                dir('./') {
                    azureWebAppPublish azureCredentialsId: 'AzDevOps', resourceGroup: "${RG_NAME}", appName: "${WEBAPP_NAME}", slotName: "${FEATURE_SLOT}", sourceDirectory: './', filePath: '**', targetDirectory: ''
                }
            }
        }
    }
}