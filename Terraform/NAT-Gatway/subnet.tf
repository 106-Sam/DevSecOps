resource "aws_subnet" "NAT-PUB-SB" {
    vpc_id = aws_vpc.NAT-VPC.id
    cidr_block = var.pubsb_cidr
    tags = {
        Name = "NAT-PUB-SB"
    }

}
resource "aws_subnet" "NAT-PRIV-SB" {
    vpc_id = aws_vpc.NAT-VPC.id
    cidr_block = var.privsb_cidr
    tags = {
        Name = "NAT-PRIV-SB"
    }
}