resource "aws_vpc" "VPCA"{
    cidr_block= var.vpca_cidr
    tags = {
        Name = "VPCA"
    }
}

resource "aws_vpc" "VPCB"{
    cidr_block = var.vpcb_cidr
    tags = {
        Name = "VPCB"
    }
}


resource "aws_subnet" "subnetA"{
    vpc_id = aws_vpc.VPCA.id
    cidr_block = var.subnetA_cidr
    availability_zone = var.region
    tags = {
        Name = "subnetA"
    }
}


resource "aws_subnet" "subnetB"{
    vpc_id = aws_vpc.VPCB.id
    cidr_block = var.subnetB_cidr
    availability_zone = var.region
    tags = {
        Name = "subnetB"
    }
}

