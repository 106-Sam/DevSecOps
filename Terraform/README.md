# Terraform

**Index of Content**

1. [Terraform Introduction](https://github.com/106-Sam/DevOps/tree/main/Terraform#1-terraform-introduction)
2. [VPC Peering](https://github.com/106-Sam/DevOps/tree/main/Terraform#2-vpc-peering)
3. [NAT Gateway]()
4. [Backend Block]()
5. [Datasource Block]()
6. [Terraform Import]()
7. [RDS using Secret Manager]()
8. [Provisioner in Terraform]()



## 1. Terraform Introduction


Try to create resources manually and simentanously create using the Terraform tool.

AWS has Cloud Formation Templates 
Azure has ARM templates 
Both work under its own cloud only but Terraform works with all the clouds.



Terraform is one of the IaaC (Infrastructure as a code), which can be used to create the infrastructures like resources VPC, EC2 Instances, Security Groups, Route Tables.

- It supports multiple cloud providers [AWS, Azure, GCP] and 200+ other cloud providers
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

``` hcl
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


To perform VPC Peering we require below resources:
1. Two or more VPC (in same/different region/availability zones)
2. subnets (SB)
3. internet gateways (IGW)
4. default route tables (RT)
5. default security groups (SG)
6. VPC Peering & Accepter
7. EC2


*Arguments* - Arguments are nothing but input values that we can add in the resource. For example, cidr_block = 10.0.0.0/16

*Attributes* - Attributes are nothing but output values that we can get the return values. For example, for subnets vpc_id = aws_vpc.vpcA.id, where 'VPCA' is Reference Name.

we can write all the code in one file but to make things efficient and easier for troubleshooting.

#### Provider Block

``` hcl

# Provider Block 
provider "aws" {
    region = "ap-south-2"
    secret_key = ""
    access_key = ""
}
```
#### To create VPC resource

``` hcl
# Resource Block, Resource Type, Reference Name
resource "aws_vpc" "VPCA"{
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "VPCA"
    }
}

#VPCB
resource "aws_vpc" "VPCB"{
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "VPCB"
  }
}
```
We cannot edit the **Resource Block** and **Resource Type**, but we can change the **Reference Name**.

> terrafrom validate
> terrafrom plan

We can use aws cli commands to list out the vpc like `aws ec2 describe-vpcs`

> terraform apply --auto-approve 

#### To create Subnet resource

``` hcl 

# subnet A for VPC-A
resource "aws_subnet" "sb-A"{
  vpc_id = aws_vpc.VPCA.id     #resourcetype.referencename.<attributename>
  cidr_block = "10.0.1.0/24"
  tags = {
    name = "sb-A"
  }
}

# subnet B for VPC-B
resource "aws_subnet" "sb-B"{
  vpc_id = aws_vpc.VPCB.id
  cidr_block = "192.168.1.0/24"
  tags = {
    name = "sb-B"
  }
}

```
To retrive the VPC ID, we need to use this format `resourcetype.referencename.<attributename>`
ex: `aws_vpc.VPCA.id`

**Interview Question: 
How does terraform know that the vpc is already created or not?
Ans) As terraform is idempotent, terraform knows that once the resource is created, as it hold the statefile (terraform.tfstate). And we create a resources the terraform will create and have all the vpc information along with (present infrastructre information is mentioned in the statefile). It will always verfify the state file if it available or not.**


_Note:_ If resource type is same then the reference name must be unqiue.

#### TO create Internet Gateway

``` hcl 
# IGW-A for VPC_A 
resource "internet_gateway" "IGWA"{
  vpc_id = aws_vpc.VPCA.id
  tags = {
    Name = "IGWA"
  } 
}

# IGW-A for VPC-B
resource "internet_gateway" "IGWB"{
  vpc_id = aws_vpc.VPCB.id
  tags = {
    Name = "IGWB"
  }

}
```
 
#### To create/manage default route tables 

``` hcl

resource "aws_default_route_table" "RT-A"{
    default_route_table_id = aws_vpc.VPCA.default_route_table_id

    route{
      cidr_block = "10.0.1.0/24"
      gateway_id = internet_gatway.id
    }
    tags = {
      Name = "RT-A"
    }
}

resource "aws_default_route_table" "RT-B"{
  default_route_table_id = aws_vpc.VPCB.default_route_table_id

  route{
    cidr_block = "192.168.1.0/24"
    gateway_id = internet_gateway.id
  }
  tags = {
    Name = "RT-B"
  }
}

```


## 3. NAT Gateway


## 4. Backend Block


## 5. Datasource Block


## 6. Terraform Import


## 7. RDS using Secret Manager


## 8. Provisioner in Terraform

