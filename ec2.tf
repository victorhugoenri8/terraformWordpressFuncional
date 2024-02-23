
# maquina solo con nginx instalado sobre un 
# ubuntu 20

resource "aws_instance" "maquina" {
  ami           = "ami-06873c81b882339ac"
  instance_type = "t2.micro"
  key_name = "canada"
  vpc_security_group_ids = [aws_security_group.launch-wizard-3.id]
  subnet_id = aws_subnet.lana_publica.id

  tags = {
    Name = "maquina_lana3"
  }

  user_data = "${file("scriptwordpress.sh")}"

}

resource "aws_security_group" "launch-wizard-3" {
  name   = "launch-wizard-3"
  vpc_id = aws_vpc.main.id
   #Incoming traffic
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #replace it with your ip address
  }
   ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #replace it with your ip address
  }

  #Outgoing traffic
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}