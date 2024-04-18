pipeline {
    agent any

    stages {
        stage('Setup Parameters') {
          steps {
            script {
              properties([
                        parameters([
                            choice(choices: ['Default: Do Nothing', 'QTS_RTOP','QTS_Chicago','QTS_Dallas','AWS_us-east-2', 'AWS_us-west-2'],name: 'Select_The_Region', description: 'Select the Region'),
                            choice(choices: ['Default: Do Nothing', 'nessdemo.local','crit.nessdemo.local', 'ds.nessdemo.local'],name: 'Select_The_Domain', description: 'Select the Domain'),
                            choice(choices: ['Default: Do Nothing', 'Deploy', 'Destroy'],name: 'Terraform_Action', description: 'Select the Action')
                            
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
            when { expression { params.Terraform_Action == 'Deploy'  }  }
            steps {
                script {
                        bat "echo Plan"
                        bat 'terraform plan -out=tfplan'
                }
            }
        }
        stage('Terraform Apply') {
            when { expression { params.Terraform_Action == 'Deploy'  }  }
            steps {
                script {
                        bat "echo Applying"
                        bat 'terraform apply -auto-approve tfplan'
                        
                        bat "echo Upload State to S3"
                        withAWS(region: "us-east-1") {
                            s3Upload(file:'terraform.tfstate', bucket:'pnayak-demo-bucket', path:'jenkins-jobs/')
                            s3Upload(file:'windows-key-pair.pem', bucket:'pnayak-demo-bucket', path:'jenkins-jobs/')
                            bat "echo terraform statefile and windows-key-pair.pem file uploaded"
                        }
                        bat "echo Terraform Applied"
                }
            }
        }
        stage('Terraform Destroy') {
            when { expression { params.Terraform_Action == 'Destroy'  }  }
            steps {
                script {
                        bat "echo Destroying"
                        bat "echo Get the Statefile from S3"
                        withAWS(region: "us-east-1") {
                            s3Download(file:'terraform.tfstate', bucket:'pnayak-demo-bucket', path:'jenkins-jobs/terraform.tfstate', force:true) 
                        }
                        bat 'dir'
                        bat "terraform destroy -auto-approve"
                        s3Delete
                        withAWS(region: "us-east-1") {
                            s3Delete(file:'terraform.tfstate', bucket:'pnayak-demo-bucket', path:'jenkins-jobs/terraform.tfstate', force:true)
                            s3Delete(file:'windows-key-pair.pem', bucket:'pnayak-demo-bucket', path:'jenkins-jobs/windows-key-pair.pem', force:true)  
                        }
                        bat "echo terraform statefile and windows-key-pair.pem file deleted from s3 bucket"
                }
            }
        }
    }
}