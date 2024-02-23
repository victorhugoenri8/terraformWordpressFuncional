
# sudnets y solo la lana_publica tiene maquina ec2
# las demas son publicas pero sin maquina



resource "aws_subnet" "lana_publica" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_sub[0]
  tags = {
    Name = "lana_uno"
  }
  map_public_ip_on_launch = true
  availability_zone_id    = var.zonas.uno
}

resource "aws_subnet" "lana_publica2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_sub[1]
  tags = {
    Name = "lana_uno2"
  }
  map_public_ip_on_launch = true
  availability_zone_id    = var.zonas.dos
}


resource "aws_subnet" "lana_publica3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_sub[2]
  tags = {
    Name = "lana_uno3"
  }

  map_public_ip_on_launch = true
  availability_zone_id    = var.zonas.cuatro
}


resource "aws_subnet" "lana_publica4" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_sub[3]
  tags = {
    Name = "lana_uno4"
  }
  map_public_ip_on_launch = true
}

