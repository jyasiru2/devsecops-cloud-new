pipeline {
    agent any  // Use any available agent to run the pipeline



    stages {
        stage('Build Artifact - Maven') {  // Stage to build the project artifact using Maven
            steps {
                sh "mvn clean package -DskipTests=true"  // Run Maven to clean the workspace and package the project, skipping tests to save time
                archiveArtifacts 'target/*.jar'  // Archive the built JAR file for later use
            }
        }

        stage('Unit Tests - JUnit and Jacoco') {  // Stage to run unit tests and collect code coverage data
            steps {
                sh "mvn test"  // Run unit tests using Maven and JUnit
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'  // Publish the test results
                    jacoco execPattern: 'target/jacoco.exec'  // Collect code coverage data
                }
            }
        }

        stage('Mutation Tests - PIT') {  // Stage to run mutation tests using PIT
            steps {
                sh "mvn org.pitest:pitest-maven:mutationCoverage"  // Run mutation tests
            }
            post {
                always {
                    pitmutation killRatioMustImprove: false, minimumKillRatio: 50.0  // Ensure mutation coverage meets minimum threshold
                    // pitMutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'  //  Specify mutation report location
                }
            }
        }

        stage('SCM Checkout') {  // Stage to check out the source code from the source control system
            steps {
                checkout scm  // Check out the latest code from the configured SCM
            }
        }

        // Stage for SonarQube analysis is commented out
        // stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             def mvn = tool 'Default Maven';
        //             withSonarQubeEnv(installationName: 'sonarqube') {
        //                 sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=NumericApplication -Dsonar.projectName='NumericApplication' -Dmaven.clean.failOnError=false"
        //             }
        //         }
        //     }
        // }

//         stage('Vulnerability Scan - Docker') {  // Stage to perform vulnerability scans
//             steps {
//                 parallel(  // Run the scans in parallel to save time
//                   "Dependency Scan": {  // Dependency scan using OWASP Dependency Check
//                     sh "mvn dependency-check:check"  // Check for vulnerabilities in project dependencies
//                   },
//                   "Trivy Scan": {  // Trivy scan for Docker images
//                     sh "bash trivy-docker-image-scan.sh"  // Run Trivy scan script to check for vulnerabilities
//                   },
//                   "OPA Conftest": {  // OPA Conftest to check Dockerfile security policies
//                     sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'  // Test Dockerfile against security policies
//                   }
//                 )
//             }
//         }




        stage('Docker Build and Push') {  // Stage to build and push Docker image
            steps {
                withDockerRegistry([credentialsId: "docker-hub", url: ""]) {  // Use Docker Hub credentials to authenticate
                    sh 'printenv'  // Print environment variables for debugging
                    sh "docker build -t yasiru1997/numeric-app2:${GIT_COMMIT} ."  // Build Docker image with the current Git commit ID
                    sh "docker push yasiru1997/numeric-app2:${GIT_COMMIT}"  // Push the Docker image to Docker Hub
                }
            }
        }

        stage('Vulnerability Scan - Kubernetes') {  // Stage to perform security checks on Kubernetes configurations
            steps {
                sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'  // Test Kubernetes deployment file against security policies
            }
        }

        stage('Kubernetes Deployment - DEV') {  // Stage to deploy the application to a development Kubernetes environment
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubeconfig']) {  // Use Kubernetes configuration for deployment
                        sh '''sed -i "s|replace|yasiru1997/numeric-app2:${GIT_COMMIT}|g" k8s_deployment_service.yaml'''  // Replace placeholder with actual Docker image tag
                        sh "kubectl apply -f k8s_deployment_service.yaml"  // Apply the Kubernetes deployment file to deploy the application
                    }
                }
            }
        }
    }
}
