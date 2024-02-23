resource "aws_vpc" "main" {

  cidr_block = var.cidr_vpc
  tags = {
    Name = "lana-uno"
  }

  enable_dns_hostnames = true
}