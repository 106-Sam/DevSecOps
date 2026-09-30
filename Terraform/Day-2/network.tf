resource "aws_vpc" "VPCA"{
    cidr_block= "172.16.0.0/16"
    tags = {
        Name = "VPCA"
    }
}

resource "aws_vpc" "VPCB"{
    cidr_block = "172.17.0.0/16"
    tags = {
        Name = "VPCB"
    }
}


resource "aws_subnet" "subnetA"{
    vpc_id = aws_vpc.VPCA.id
    cidr_block = "172.16.1.0/24"
    availability_zone = "ap-south-2a"
    tags = {
        Name = "subnetA"
    }
}


resource "aws_subnet" "subnetB"{
    vpc_id = aws_vpc.VPCB.id
    cidr_block = "172.17.1.0/24"
    availability_zone = "ap-south-2b"
    tags = {
        Name = "subnetB"
    }
}