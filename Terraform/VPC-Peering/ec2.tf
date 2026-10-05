resource "aws_instance" "Server-A" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnetA.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_default_security_group.default-sg-A.id]
  associate_public_ip_address = true

  tags = {
    Name = "Server-A"
  }
}
resource "aws_instance" "Server-B" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnetB.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_default_security_group.default-sg-B.id]
  associate_public_ip_address = true


  tags = {
    Name = "Server-B"
  }
}