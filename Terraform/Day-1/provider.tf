# Configure the AWAS Provider
provider aws{
  region = "ap-south-2"
  access_key = ""
  secret_key = ""

}

# Create a VPC
resource "aws_vpc" "HYD-VPC2" {
  cidr_block = "172.17.0.0/16"
  tags = {
    Name = "HYD-VPC2"
  }
}