resource "aws_vpc" "NAT-VPC" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "NAT-VPC"
    }
}