node {
    stage('Choose Label') {
        AGENT_LABEL = 'my-builder'
        echo "Agent is: $AGENT_LABEL"
    }
}

pipeline {
    environment {
        //AGENT_LABEL = "my-builder"
        JSON_LOG_OUTPUT_DIR = "${WORKSPAC}/execution_log"
        ANSIBLE_FORCE_COLOR='true'
        MAVEN_OPTS = '-Djansi.force=true'
    }
    agent {
        node {
            label "${AGENT_LABEL}"
            customWorkspace "/app/jenkins/jenkins_home/workspace/${JOB_NAME}/${BUILD_NUMBER}"
        } 
    }
    // options {
    //     ansiColor('xterm')
    // }
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