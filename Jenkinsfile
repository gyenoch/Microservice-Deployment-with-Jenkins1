pipeline {
    agent any

    stages {
        stage('Deploy Kubernetes') {
            steps {
                withKubeCredentials(kubectlCredentials: [[
                    caCertificate: '',
                    clusterName: 'EKS-1',
                    contextName: '',
                    credentialsId: 'k8-token',
                    namespace: 'webapps',
                    serverUrl: 'https://14b2d3f625b31ab32fa28b8c949c2b64.gr7.us-east-1.eks.amazonaws.com/'
                ]]) {
                    sh "kubectl apply -f deployment-service.yml"
                    sleep 60
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                withKubeCredentials(kubectlCredentials: [[
                    caCertificate: '',
                    clusterName: 'EKS-1',
                    contextName: '',
                    credentialsId: 'k8-token',
                    namespace: 'webapps',
                    serverUrl: 'https://14b2d3f625b31ab32fa28b8c949c2b64.gr7.us-east-1.eks.amazonaws.com/'
                ]]) {
                    sh "kubectl get svc -n webapps"
                }
            }
        }
    }
}

