pipeline {
  agent any

  stages {

    stage('Build Artifact') {
                steps {
                  sh "mvn clean package -DskipTests=true"
                  archive 'target/*.jar' //so that they can be downloaded later
                }
    }

    stage('maven version') {
      steps {
        sh "mvn -v"
      }
    }

    stage('docker version') {
      steps {
        sh "docker -v"
      }
    }

    stage('kubernetes version') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh "kubectl version --short"
        }
      }
    }
  }
}