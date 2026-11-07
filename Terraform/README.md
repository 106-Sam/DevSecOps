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
- `terraform apply --auto-approve`: it will auto approve and create all the resource
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
    route{
        cidr_block = var.subnetA_cidr
        vpc_peering_connection_id = aws_vpc_peering_connection.VPCA-VPCB.id
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
  route{
        cidr_block = var.subnetA_cidr
        vpc_peering_connection_id = aws_vpc_peering_connection.VPCA-VPCB.id
  tags = {
    Name = "RT-B"
  }
}
```
#### To create/manage default security group

``` hcl 

resource "aws_default_security_group" "SG-A"{
  vpc_id = aws_vpc.VPCA.id

  ingress {
    protocol = "tcp"
    self = true
    from_port = 22
    to_port = 22
    cidr_block = [0.0.0.0/0]
  }
  ingress{
    protocol = "icmp"
    self = true
    from_port = -1
    to_port = -1
    cidr_block = [192.168.1.0/24]
  }
  egress {
    portocol = -1
    self = true
    from_port = -1
    to_port = -1
    cidr_block = [192.168.1.0/24]
  }
  tags = {
    Name = SG-A
  }
}

resource "aws_default_security-group" "SG-B"{
  vpc_id = aws_vpc.VPCB.id

  ingress {
    protocol = "tcp"
    self = true
    from_port = 22
    to_port = 22
    cidr_block = [0.0.0.0/0]
  }
  ingress{
    protocol = "icmp"
    self = true
    from_port = -1
    to_port = -1
    cidr_block = [10.0.1.0/24]
  }
  egress {
    portocol = -1
    self = true
    from_port = -1
    to_port = -1
    cidr_block = [10.0.1.0/24]
  }
  tags = {
    Name = "SG-B"
  }
}

```

#### To create vpc peering  connection with autoaccepter
``` hcl
resource "aws_vpc_peering_connection" "VPCA-VPCB" {
  peer_vpc_id   = aws_vpc.VPCB.id
  vpc_id        = aws_vpc.VPCA.id
  auto_accept   = true

  tags = {
    Name = "VPCA-VPCB"
  }
}
```

#### To create EC2 Instance 
```hcl 
resource "aws_instance" "Server-A" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnetA.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_default_security_group.default-sg-A.id]
  associate_public_ip_address = true

  tags = {
    Name = "Server-A"
  }
}
resource "aws_instance" "Server-B" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnetB.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_default_security_group.default-sg-B.id]
  associate_public_ip_address = true


  tags = {
    Name = "Server-B"
  }
}
```

## 3. NAT Gateway

if terraform .tfstate file is deleted, as a DevOps Engineer, we can't manage the terraform created infrastructure.

### Terraform basics1

#### Terraform Variable
Whenever we use/define the variable like `var.ipaddress` or `var.ipvpca` , we need to declare a variable block as well.

- There are many way to use variables:

1. Use variable block and providing the variable value in it.

``` hcl 

# Define Variable 
resource "aws_vpc" "VPCA"{
  cidr_block = var.ipvpca
}
```
filename : variable.tf

``` hcl 
#declare variable
variable "ipvpca"{
  default = "10.0.0.0/16"
}
```

2. using `terraform.tfvars` file  which is default .tfvar filename and terraform picks the variable value from the `.tfvars` files first which might override the `variable.tf` declarations

filename: terraform.tfvars
```hcl 
ipvpca = "10.1.0.0/16"
}
```

SO, the best way is to use the `.tfvars` file and update the `variable.tf` file.-

filename: variable.tf
```hcl 

variable "ipvpca" {}
```

3. In case, you don't like to use default name `terraform.tfvars` or created with different name we need explicitly provide it as an ARGument point out thvariable "ipvpca"{
  default = "10.0.0.0/16"at file `.tfvars` file we don't then it will prompt us for value while `terraform plan` or `terraform apply --auto-approve`

> terraform plan/apply --var-file <fileNamewithPATH>
`terraform plan/apply --var-file <fileNamewithPATH>`.

#### Terraform State file CLI

- In case, if you changed the reference name after creating the resource, the terraform thinks its new configuration and old configuration gets deleted.
- We need to rename that reference name in the statefile via CLI (recommended)

`terraform state list` - it will read the statefile and list us the resources

`terraform state` - it will display the help menu

`terraform state mv aws_vpc.VPCA aws_vpc.VPCB` - It will rename the reference name for VPCA with VPCB. `terraform state mv <previousRefname> <newRefName`

To perform NAT GATWAY we require below resources/Steps in order:
1.  


## 4. Backend Block

### Terraform basics2

#### Terraform Backend

What is backend block ?
To store our statefile in the S3 bucket


``` hcl
resource "aws_s3_bucket" "example" {
  bucket = "<unique_name_for_bucket>"
  tags = {
    Name = "<unique_name_for_bucket>"
  }
}
```

Now I want to store the .tfstate file in the s3 bucket and not local machine for that we use backend block

filename: Provider.tf

```hcl 
# Configure Provider
provider "aws" {
    region = "ap-south-2"
    access_key =  var.accesskey
    secret_key = var.secretkey
}

teraform{
  backend "s3" {
    bucket = "<unique_name_for_bucket>"
    key = "<filename>.tfstate"
    region = "ap-south-2
  }
}

```

Here backend block doesn't take the credentials from the Provider block it takes it from the aws cli authentication in the terminal.

`aws configure` - add the access_keys and secret_keys 

After setup do again `terraform init` 

#### Terraform Destroy must not delete the state file

if we try to do `terraform destory` we will lose the .tfstate file. 

however, s3 doesn't get deleted as the s3 bucket isn't empty only the empty buckets get deleted.

Therefore, we will remove the s3 bucket details from the statefile via `terraform state` commands 

`terraform state list` - to list all the resources
`terraform state` - to get the help menu for cli
`terraform state rm aws_s3_bucket.<bucketReferenceName>` - to delete the s3 bucket from state file
`terraform state list` - s3 bucket will not be listed now.

#### Terraform Destory 

- we can destroy the resource by just remove the code from the .tf files 
- we can also destory it by using below way for specific resource 

`terraform state list` 
`terraform destory -target aws_subnet.<subnetReferenceName>`  - to destory a specific resource from statefile and also resource

#### Storing statefile in the centralized location 

- it helps multiple users work on the same project in the terraform 

#### Output block 

We use output block to print out the value. We require after the resource are created and running

example:

```hcl 

output "ServerA_Public_IP" {
  value = aws_instance.Server-A.public_ip
}
output "ServerA_Private_IP"{
    value = aws_instance.Server-A.private_ip
}
output "ServerB_Public_IP" {
  value = aws_instance.Server-B.public_ip
}
output "ServerB_Private_IP"{
    value = aws_instance.Server-B.private_ip
}
output "vpc_id"{
  value = aws_vpc.my_vpc.id
}

```

We get output only when after we do `terraform apply` as only then the resource are created.

#### Terraform Console cli 

We use `terraform console` command to check if the variable we declared in the terraform code are getting what inputs.

`terraform console`
> `var.vpc-name

#### Depends_on block Terraform

- Terraform doesn't know about the sequence, so it created the resources randomly. Hence, we can use `depends_on` block to get it sequencely

one of the meta argument is "depends_on" 

We use `depends_on` to execute the terraform code in the sequentical order we use depends on.

example:

```hcl 

resource "aws_vpc" "VPCA"{
    cidr_block= var.vpca_cidr
    tags = {
        Name = "VPCA"
    }
}

resource "aws_subnet" "subnetA"{
    vpc_id = aws_vpc.VPCA.id
    cidr_block = var.subnetA_cidr
    availability_zone = var.region
    tags = {
        Name = "subnetA"
    }
    depends_on = [aws_vpc.VPCA]
}
resource "aws_internet_gateway" "igwA" {
    vpc_id = aws_vpc.VPCA.id
    tags = {
        Name = "igwA"
    }
    depends_on = [aws_vpc.VPCA]
}

```

## 5. Datasource & Import Block

We use `data block` to read any existing resources

Examples:

```hcl 

data "aws_vpc" "existingVPC1"{
  id = "vpc-xxxxx"
}
```

Now to test if this VPC really exists we use output block to verify:

```hcl
output "vpc_id" {
  value = data.aws_vpc.existingVPC1.id
}

```
IF same vpc id is printed means it is working.

To know cidr_block and etc use the same output block to list out what is the cidr range for that VPC.

```hcl 
output "cidr_id"{
  value = data.aws_vpc.exitingVPC1.cidr_block
}
```

#### To list out the existing Subnet ID in a given VPC ID

```hcl

data "aws_subnets" "exisitngSub"{
  filter{
    name = "vpc-id"
    value = [var.vpc_id]
  }
}

variable "vpc_id"{
  type = string
  default = "vpc-xxxxx"
}

output "subnet_ids" {
  value = data.aws_subnets.existingSub.ids
}
```
#### Import state file to prevent data blocks

- First, Infra Team will create all the resource (VPC, SG, RT, IGW...etc) let suppose the team is using remote location like S3 bucket using backend block.
- Operation team can import it using data block.


filename: provider.tf
```hcl 
# Configure Provider
provider "aws" {
    region = "ap-south-2"
    access_key =  var.accesskey
    secret_key = var.secretkey
}

data "terraform_remote_state" "networks"{
  backend = "s3"

  config = {
    bucket = "<bucketName>"
    key = "prod.tfstate" # Must match the exact key from Project A
    region = "ap-south-2"

  }
}
```
`terraform init`

- Copy the AMI ID from EC2 instance

filename: ec2.tf

```hcl 
resource "aws_instance" "Server-A"{
  ami = "ami-xxxxxx"
  instance_type = "t3.micro"
  key_name = "<existingKeysName>"
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id
  associate_public_ip_address = true
  
  # vpc_security_group_ids = [data.terraform_remote_state.network.outputs.default_security_group_id]

  tags = {
    Name = "Server_A"
  }
}
```

## 6. Terraform Import


## 7. RDS using Secret Manager


## 8. Provisioner in Terraform

