# Terraform

**Index of Content**

1. [Terraform Introduction](https://github.com/106-Sam/DevOps/tree/main/Terraform#1-terraform-introduction)
2. [VPC Peering](https://github.com/106-Sam/DevOps/tree/main/Terraform#2-vpc-peering)



## 1. Terraform Introduction


Try to create resources manually and simentanously create using the Terraform tool.

AWS has Cloud Formation Templates 
Azure has ARM templates 
Both work under its own cloud only but Terraform works with all the clouds.



Terraform is one of the IaaC (Infrastructure as a code), which can be used to create the infrastructures like resources VPC, EC2 Instances, Security Groups, Route Tables.

- It supports multiple cloud providers [AWS, Azure, GCP]
- It is idempotent [if you run same script, present infra will not change] as it holds state file.
- We can plan the execution [`terraform plan`]
- We can split configuration in multiple files
    - Example, 

            vpc.tf ==> VPC code
            s3.tf ==> S3 code
- We can import manually created resources into the Terraform [Normally, Terraform can manage only the resources created with its CLI but not the ones we created manually, yet we can import them and manage]
- terraform file extension [.tf]
- Terraform has two major blocks:
  - Provider Block - 
    In provider block, we need to mention which cloud we are using, otherwise it won't know.
  
  - Resource Block - 
    In Resource Block, we need to mention which resource we are creating.


- `terraform init`: it will download provider related plugins [.terraform]
- `terraform validate`: it will validate code syntax
- `terraform plan`: it will show execution plan
- `terraform apply`: it will create all resources
- `terraform destory`: it will destory all resources
- `terraform fmt`: it will indent/format our code

Install the terraform from the offical sites of Hashicorp.

Terraform commands can execute from Powershell, Command Prompt, Visual Studio Code.

We need to set the Environment Path on windows 
- C drive, right click > properties > advance system settings > select environment variable.
- Top for user, bottom for System 
- Select the "Path" > Edit button > then click New > provide the path > Ok

Install Hashicorp Terraform Plugin in VS Code.

[registry.terraform.io](https://registry.terraform.io/) - has all the provider information over here on the site.

Version setting block is important.

``` 
# Version Setting Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}



# Configure the AWS Provider
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "<name>"
  }
}
```

`terraform init`

after/before this best part is create an IAM user, provide access to resources, and keep its access keys and secret key handy.

We usually hide the credentials in the .env file but as per the practice now

`terraform plan`
`terraform apply` > yes


## 2. VPC Peering

[Terraform code](https://github.com/106-Sam/DevOps/tree/main/Terraform/VPC-Peering)





