pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/sai25052001/semi-colon.git'
            }
        }
        stage('Build Java Project') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Run Trivy Scan') {
            steps {
                sh 'trivy fs --format json --output trivy-report.json .'
            }
        }
        stage('Parse Trivy Report') {
            steps {
                sh 'python3 parse_trivy.py'
            }
        }
        stage('auto fixing the CVEs') {
            steps {
                sh 'python3 auto_fix_cves.py'
            }
        }
        stage('Run Trivy Scan again to check the CVEs') {
            steps {
                sh 'trivy fs --format json --output trivy-report.json .'
            }
        }
        stage('Update new Dependencies in git') {
            steps {
                sh 'git config --global user.email "sai25052001@gmail.com"'
                sh 'git config --global user.name "sai25052001"'
                sh 'git add pom.xml'
                sh 'git commit -m "Auto-updated dependencies based on Trivy scan"'
                withCredentials([string(credentialsId: 'github-credentials', variable: 'GIT_TOKEN')]) {
                sh 'git push https://sai25052001:$GIT_TOKEN@github.com/sai25052001/semi-colon.git main'
                }
            }
        }
        stage('Deploy & Test') {
            steps {
                sh 'mvn test'
                sh 'mvn verify'
            }
        }
    }
}

