pipeline {
    environment {
        AGENT_LABEL = "my-builder"
        JSON_LOG_OUTPUT_DIR = "${WORKSPAC}/execution_log"
    }
    agent {
        node {
            label "${AGENT_BUILDER}"
            customWorkspace "/app/jenkins/jenkins_home/workspace/${JOB_NAME}/${BUILD_NUMBER}"
        }
    }
    options {
        ansiColor('xterm')
    }
    stages {
        stage('Checkout SCM') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'feature/az']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'CleanBeforeCheckout']],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Sebastian-Negoescu/snprofile-django.git'
                    ]]
                ])
            }
        }
        stage('List Items') {
            steps {
                sh 'pwd'
                sh 'ls -la'
            }
        }
    }
}