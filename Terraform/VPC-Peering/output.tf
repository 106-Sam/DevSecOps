output "ServerA_Public_IP" {
  value = aws_instance.Server-A.public_ip
}
output "ServerA_Private_IP"{
    value = aws_instance.Server-A.private_ip
}
output "ServerB_Public_IP" {
  value = aws_instance.Server-B.public_ip
}
output "ServerB_Private_IP"{
    value = aws_instance.Server-B.private_ip
}