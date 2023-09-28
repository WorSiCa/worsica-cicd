@Library(['github.com/indigo-dc/jenkins-pipeline-library@stable/2.1.0']) _

def projectConfig

pipeline {
    agent { label 'worsica' }

    options {
        //lock('worsica')
        throttle(['StandaloneByNode'])
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }

    stages {
        stage('SQA baseline dynamic stages') {
            when {
                anyOf {
                    branch 'master'
                    branch 'development'
                }
            }
            steps {
                script {
                    projectConfig = pipelineConfig()
                    buildStages(projectConfig)
                }
            }
            post {
                success {
                    slackSend(//baseUrl: "https://worsica.slack.com",
                              teamDomain: "worsica",
                              channel: "#jenkins",
                              tokenCredentialId: "worsica_slack",
                              botUser: true,
                              //username: "JenkinsButler",
                              message: "[${env.JOB_NAME}:${env.BUILD_NUMBER}] Pipeline have completed with success.\nMore details at <${env.JOB_DISPLAY_URL}|Jenkins site>.",
                              color: "good")
                }

                failure {
                    slackSend(//baseUrl: "https://worsica.slack.com",
                              teamDomain: "worsica",
                              channel: "#jenkins",
                              tokenCredentialId: "worsica_slack",
                              botUser: true,
                              //username: "JenkinsButler",
                              message: "[${env.JOB_NAME}:${env.BUILD_NUMBER}] Pipeline failed.\nPlease check the logs for <${env.RUN_DISPLAY_URL}|job ${env.BUILD_NUMBER}>.\nMore details at <${env.JOB_DISPLAY_URL}|Jenkins site>.",
                              color: "warning")
                }

                cleanup {
                    cleanWs()
                }
            }
        }
    }
}
