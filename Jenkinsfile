pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        NVD_API_KEY = credentials('nvd-api-key')
    }

    stages {
        stage('Cleaning Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Sonarqube Code Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''
                    $SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectName=cartservice \
                    -Dsonar.projectKey=cartservice
                    '''
                }
            }
        }

        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token' 
                }
            } 
        }

        stage('OWASP Dependency-Check') {
            steps {
                    dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit --nvdApiKey ${NVD_API_KEY}', odcInstallation: 'DP-Check'
                    dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Trivy File Scan') {
            steps {
                    sh 'trivy fs . >> trivyfs.txt'
                    script {
                        def scanResults = readFile('trivyfs.txt')
                        if (scanResults.contains('CRITICAL')) {
                            echo "Warning: Critical vulnerabilities found in frontend file scan!"
                        }
                    }
            }
        }

        stage('Build & Tag Docker Image') {
            steps {
                script {
                    dir('src') {
                        withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                            sh "docker build -t gyenoch/cartservice:latest ."
                        }
                    }
                }
            }
        }
        
        stage('Docker Image Scan') {
            steps {
                sh 'trivy image gyenoch/cartservice:latest >> trivyimage.txt'
                script {
                    def scanResults = readFile('trivyimage.txt')
                    // Log the scan results without throwing an error
                    echo "Cartservice scan results:\n${scanResults}"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker push gyenoch/cartservice:latest "
                    }
                }
            }
        }
    }
}


// pipeline {
//     agent any

//     stages {
//         stage('Build & Tag Docker Image') {
//             steps {
//                 script {
//                     dir('src') {

//                     withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
//                         sh "docker build -t gyenoch/cartservice:latest ."
//                     }
//                         }
//                 }
//             }
//         }
        
//         stage('Push Docker Image') {
//             steps {
//                 script {
//                     withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
//                         sh "docker push gyenoch/cartservice:latest "
//                     }
//                 }
//             }
//         }
//     }
// }
