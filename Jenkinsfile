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
                            choice(choices: ['Default: Do Nothing', 'Deploy', 'Destroy-For-testing-Purposes'],name: 'Terraform_Action', description: 'Select the Action')
                            
                        ])
                    ])
            }
          }
        }
        stage('Checkout Code') {
            steps {
				script {
					git branch: 'main', url: 'https://github.com/panchnayak/terraform-ad.git'
					bat 'dir'
				}
            }
        }
        
        stage('Terraform Init') {
            
            steps {
                script {
                    bat 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            when { expression { params.ACTION_REQUESTING == 'Apply'  }  }
            steps {
                script {
                        bat "echo Plan"
                        bat 'terraform plan -out=tfplan'
                }
            }
        }
        stage('Terraform Apply') {
            when { expression { params.ACTION_REQUESTING == 'Apply'  }  }
            steps {
                script {
                        bat "echo Applying"
                        bat 'terraform apply -auto-approve tfplan'
                        
                        bat echo "Upload State to S3"
                        withAWS(region: "us-east-1") {
                        s3Upload(file:'terraform.tfstate', bucket:'pnayak-demo-bucket', path:'jenkins-jobs/')
                    }
                }
            }
        }
        stage('Terraform Destroy') {
            when { expression { params.ACTION_REQUESTING == 'Destroy-For-testing-Purposes'  }  }
            steps {
                script {
                    bat echo "Get the Statefile from S3"
                    withAWS(region: "us-east-1") {
                        s3Download(file:'terraform.tfstate', bucket:'pnayak-demo-bucket', path:'jenkins-jobs/terraform.tfstate', force:true) 
                    }
                    bat "echo Destroying"
                    bat 'terraform destroy -auto-approve'
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