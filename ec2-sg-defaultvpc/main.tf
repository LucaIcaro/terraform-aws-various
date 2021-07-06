data "aws_ami" "amazonlinux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*.0-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "random_pet" "server_name" {
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.amazonlinux2.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [ aws_security_group.server.id ]

  key_name = var.key_name

  tags = {
    Name = "Test-${random_pet.server_name.id}"
    env  = "test"
  }
}

resource "aws_security_group" "server" {
  name = "${random_pet.server_name.id}-instance"
}

resource "aws_security_group_rule" "personalssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [ var.personal_ip ]
  security_group_id = aws_security_group.server.id
}

resource "aws_security_group_rule" "openall" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.server.id
}
