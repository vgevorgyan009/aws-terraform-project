// 
def gv

pipeline {
  agent any
  tools {
       maven 'maven-3.9'
  }
  environment {
        IMAGE_NAME = 'vgevorgyan009/demo-app:java-maven-17.0'
  }
  stages {
    stage("init") {
        steps {
            script {
                gv = load "script.groovy"
            }
        }
    }
    stage("build app jar") {        
      steps {
          script {
              echo 'building application jar...'
              gv.buildJar()
          }
      }
    }

    stage("provision server") {
        environment {
            AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
            AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
            TF_VAR_env_prefix = 'test'
        }
        steps {
            script {
                dir('terraform') {
                    sh "terraform init"
                    sh "terraform apply --auto-approve"
                    EC2_PUBLIC_IP = sh(
                        script: "terraform output ec2_public_ip",
                        returnStdout: true
                    ).trim()
                }
            }
        }
    }

    stage("build image") {        
      steps {
          script {
              gv.buildImage()
          }
      }
    }
    stage("deploy") {
        environment {
            DOCKER_CREDS = credentials('docker-hub-repo')
        }
        steps {
            script {
                echo "waiting for EC2 server to initialize"
                sleep(time: 90, unit: "SECONDS")

                echo "Deploying docker image to EC2..."
                echo "${EC2_PUBLIC_IP}"

                def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME} ${DOCKER_CREDS_USR} ${DOCKER_CREDS_PSW}"
                def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"

                sshagent(['server-ssh-key']) {
                sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"   
                sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user" 
                sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                }
            }
        } 
     } 
   }
}
