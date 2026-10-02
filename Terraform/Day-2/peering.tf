resource "aws_vpc_peering_connection" "VPCA-VPCB" {
  peer_vpc_id   = aws_vpc.VPCB.id
  vpc_id        = aws_vpc.VPCA.id
  auto_accept   = true

  tags = {
    Name = "VPCA-VPCB"
  }
}