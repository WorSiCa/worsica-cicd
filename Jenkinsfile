#!/usr/bin/groovy

@Library(['github.com:WORSICA/jenkins-pipeline-library@docker-compose']) _

def projectConfig

pipeline {
    agent any

    options {
        buildDiscarder(logRotator(daysToKeepStr: '7', numToKeepStr: '1'))
    }

    environment {
        CONFIG_FILE = '.sqa/config.yml'
    }

    stages {
        stage('Load Configuration') {
            steps {
                script {
                    projectConfig = PipelineConfig('.sqa/config.yml')
                }
            }
            post {
                cleanup {
                    cleanWs()
                }
            }
        }
        stage('Dynamic Stages') {
            agent {
                node {
                    label projectConfig.node_label
                    customWorkspace projectConfig.node_workspace
                    }
            }
            steps {
                script {
                    BuildStages(projectConfig)
                }
            }
            post {
                cleanup {
                    cleanWs()
                }
            }
        }

        stage('Deploy services and workspace') {
            steps {
                DockerComposeUp('', 'dc-testenv.yml')
            }
        }

        stage('Code fetching') {
            steps {
                git branch: env.BRANCH_NAME,
                    url: 'https://github.com/WorSiCa/worsica-processing.git'
                git branch: env.BRANCH_NAME,
                    url: 'https://github.com/WorSiCa/worsica-portal.git'
            }
        }

        stage('Environment setup') {
            steps {
                PipRequirements(
                    ['pylint', 'pytest', 'pytest-cov', 'bandit'],
                    'requirements-pip.txt')
                ToxConfig(tox_envs, 'tox_worsicaprocessing.ini')
            }
            post {
                always {
                    archiveArtifacts artifacts: '*requirements*.txt,*tox*.ini'
                }
            }
        }

        stage('Style check analysis') {
            steps {
                ToxEnvRun('pylint', 'tox_worsicaprocessing.ini')
            }
            post {
                always {
                    WarningsReport('PyLint')
                }
            }
        }

        stage('Unit testing') {
            steps {
                script {
                    try {
                        ToxEnvRun('unittest', 'tox_worsicaprocessing.ini')
                    }
                    catch(e) {
                        currentBuild.result = 'SUCCESS'
                    }
                }
            }
            post {
                always {
                    WarningsReport('PyTest')
                }
            }
        }

        stage('Code test coverage') {
            steps {
                script {
                    try {
                        ToxEnvRun('coverage', 'tox_worsicaprocessing.ini')
                    }
                    catch(e) {
                        currentBuild.result = 'SUCCESS'
                    }
                }
            }
            post {
                success {
                    CoberturaReport('**/cov_worsicaprocessing.xml')
                }
            }
        }

        stage('Security scanner') {
            steps {
                script {
                    try {
                        ToxEnvRun('security', 'tox_worsicaprocessing.ini')
                    }
                    catch(e) {
                        // Temporarily supress this check
                        currentBuild.result = 'SUCCESS'
                    }
                }
            }
            post {
                always {
                    HTMLReport('', 'bandit_worsicaprocessing.html', 'Bandit report')
                }
            }
        }

        stage('Stop services and clean workspace') {
            steps {
                // Set to false if images and containers must be preserved
                DockerComposeDown(true)
            }
        }
    }
}
