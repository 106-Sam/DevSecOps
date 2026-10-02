resource "aws_default_route_table" "default_route_tableA" {
    default_route_table_id = aws_vpc.VPCA.default_route_table_id

    route{
        cidr_block = var.anyipaddress
        gateway_id = aws_internet_gateway.igwA.id
    }
    tags = {
        Name = "default-RT-A"
    }
}

resource "aws_default_route_table" "default_route_tableB"{
    default_route_table_id = aws_vpc.VPCB.default_route_table_id

    route{
        cidr_block = var.anyipaddress
        gateway_id = aws_internet_gateway.igwB.id
    }
    tags = {
        Name = "default-RT-B"
    }

}