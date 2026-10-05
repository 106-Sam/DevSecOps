resource "aws_default_route_table" "default_route_tableA" {
    default_route_table_id = aws_vpc.VPCA.default_route_table_id

    route{
        cidr_block = var.anyipaddress
        gateway_id = aws_internet_gateway.igwA.id
    }
    route{
        cidr_block = var.subnetB_cidr
        vpc_peering_connection_id = aws_vpc_peering_connection.VPCA-VPCB.id
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
    route{
        cidr_block = var.subnetA_cidr
        vpc_peering_connection_id = aws_vpc_peering_connection.VPCA-VPCB.id
    }
    tags = {
        Name = "default-RT-B"
    }

}