resource "aws_internet_gateway" "igwA" {
    vpc_id = aws_vpc.VPCA.id
    tags = {
        Name = "igwA"
    }
}

resource "aws_internet_gateway" "igwB" {
    vpc_id = aws_vpc.VPCB.id
    tags = {
        Name = "igwB"
    }
}