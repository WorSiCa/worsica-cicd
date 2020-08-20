@Library(['github.com/indigo-dc/jenkins-pipeline-library@feature/docker_compose_push']) _

def projectConfig

pipeline {
    agent any

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
                cleanup {
                    cleanWs()
                }
            }
        }
    }
}
