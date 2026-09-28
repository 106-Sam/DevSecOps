# Terraform

**Index of Content**

1. [Terraform Introduction](https://github.com/106-Sam/DevOps/tree/main/Terraform#1-terraform-introduction)
2. 



## 1. Terraform Introduction


Try to create resources manually and simentanously create using the Terraform tool.



Terraform is one of the IaaC (Infrastructure as a code), which can be used to create the infrastructures like resources VPC, EC2 Instances, Security Groups, Route Tables.

- It supports multiple cloud providers [AWS, Azure, GCP]
- It is idempotent [if you run same script, present infra will not change] as it holds state file.
- We can plan the execution [`terraform plan`]
- We can split configuration in multiple files
    - Example, 

            vpc.tf ==> VPC code
            s3.tf ==> S3 code
- We can import manually created resources into the Terraform [Normally, Terraform can manage only the resources created with its CLI but not the ones we created manually, yet we can import them and manage]





