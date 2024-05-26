pipeline {
  agent any

  stages {

    stage('Build Artifact') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true // Corrected archive command
      }
    }

    stage('Maven Version') {
      steps {
        sh "mvn -v"
      }
    }

    stage('Docker Version') {
      steps {
        sh "docker -v"
      }
    }

    stage('Kubernetes Version') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh "kubectl version --short"
        }
      }
    }
  }
}
