resource "aws_default_security_group" "default-sg-A" {
  vpc_id = aws_vpc.VPCA.id

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    protocol  = "icmp"
    from_port = -1
    to_port   = -1
    cidr_blocks = [var.subnetB_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "default-sg-A"
  }
}

resource "aws_default_security_group" "default-sg-B" {
  vpc_id = aws_vpc.VPCB.id

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    protocol  = "icmp"
    from_port = -1
    to_port   = -1
    cidr_blocks = [var.subnetA_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "default-sg-B"
  }
}