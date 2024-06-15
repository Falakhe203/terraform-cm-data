pipeline {
    agent any

    tools {
        gradle 'Gradle-6.2'
    }
    stages {
        stage("run frontend") {
            steps {
                echo 'executing yarn...'
                nodejs('NodeJS-10.17') {
                    sh 'yarn install'
                }
            }
        }
        stage("run backend") {
            steps {
                sh 'gradle init'
                echo 'executing gradle...'
                sh 'gradle --version'
            }
        }
    }
}
