pipeline {
    agent any

    stages {
        stage('Setup Parameters') {
          steps {
            script {
              properties([
                        parameters([
                            choice(choices: ['Default: Do Nothing', 'QTS_RTOP','QTS_Chicago','QTS_Dallas','AWS_us-east-2', 'AWS_us-west-2'],name: 'Select_The_Region', description: 'Select the Region'),
                            choice(choices: ['Default: Do Nothing', 'theocc.net','crit.theocc.net', 'ds.theocc.net'],name: 'Select_The_Domain', description: 'Select the Domain'),
                            choice(choices: ['Default: Do Nothing', 'Deploy', 'Destroy-For_testing-Purposes'],name: 'Terraform_Action', description: 'Select the Action')
                            
                        ])
                    ])
            }
          }
        }
        stage('Checkout Code') {
            steps {
				script {
					git url: 'https://github.com/panchnayak/terraform-test.git'
					sh 'ls -la'
				}
            }
        }
        
        stage('Terraform Init') {
            
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Get the Statefile from S3') {
            when { expression { params.ACTION_REQUESTING == 'Destroy'  }  }
            steps {
                script {
                    withAWS(credentials: "AWS_CREDS", region: "us-east-1") {
                        s3Download(file:'terraform.tfstate', bucket:'pnayak-demo-bucket', path:'jenkins-jobs/terraform.tfstate', force:true) 
                    }
                }
            }
        }
        stage('Terraform Plan') {
            when { expression { params.ACTION_REQUESTING == 'Apply'  }  }
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'cloudbees-demo',keyFileVariable: 'SSH_KEY')]) {
                        sh "echo Plan"
                        sh 'cp "$SSH_KEY" cloudbees-demo.pem'
                        sh 'terraform plan -out=tfplan'
                    }  
                }
            }
        }
        stage('Terraform Apply') {
            when { expression { params.ACTION_REQUESTING == 'Apply'  }  }
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'cloudbees-demo',keyFileVariable: 'SSH_KEY')]) {
                        sh "echo Applying"
                        sh 'cp "$SSH_KEY" cloudbees-demo.pem'
                        sh 'terraform apply -auto-approve tfplan'
                    }  
                }
            }
        }
        stage('Terraform Destroy') {
            when { expression { params.ACTION_REQUESTING == 'Destroy'  }  }
            steps {
                script {
                    sh "echo Destroying"
                    sh 'terraform destroy -auto-approve'
                    
                }
            }
        }
       
        stage('Upload State to S3') {
            when { expression { params.ACTION_REQUESTING == 'Apply'  }  }
            steps {
                script {
                    withAWS(credentials: "AWS_CREDS", region: "us-east-1") {
                        s3Upload(file:'terraform.tfstate', bucket:'pnayak-demo-bucket', path:'jenkins-jobs/')
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
    }
}