resource "aws_security_group" "bastion_host" {
  name        = "bastion_security_group"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.bastion_host.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_1" {
  security_group_id = aws_security_group.bastion_host.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports / all protocols
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_1" {
  security_group_id = aws_security_group.bastion_host.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports / all protocols
}


resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file("${path.module}/bastion-key.pub")
}

resource "aws_instance" "bastion_host" {
  ami           = "ami-03250b0e01c28d196" # Ubuntu 24.04 AMI in eu-central-1
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_id

  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  key_name               = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "car-rental-bastion-host"
  }
}
