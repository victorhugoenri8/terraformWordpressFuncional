output "vpc_id" {
  value = aws_vpc.main.id
  #value = aws_instance.maquina.id
}
output "ip-publica" {
  description = "ip publica de la maquina"
  value       = aws_instance.maquina.public_ip
}