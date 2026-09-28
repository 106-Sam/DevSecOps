# Configure the AWAS Provider
provider aws{
  region = "ap-south-2"
  access_key = "AKIA6DINGSHLDZAIZBVL"
  secret_key = "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"

}

# Create a VPC
resource "aws_vpc" "HYD-VPC2" {
  cidr_block = "172.17.0.0/16"
  tags = {
    Name = "HYD-VPC2"
  }
}