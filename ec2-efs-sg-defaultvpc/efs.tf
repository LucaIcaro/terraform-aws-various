data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_efs_file_system" "testefs" {
  creation_token = "efs-${random_pet.server_name.id}"

  tags = {
    Name = "efs-${random_pet.server_name.id}"
  }
}

resource "aws_efs_mount_target" "alpha" {
  for_each = data.aws_subnet_ids.default.ids

  file_system_id = aws_efs_file_system.testefs.id
  subnet_id      = each.value

  security_groups = []
}

resource "aws_security_group" "testefs" {
  name = "${random_pet.server_name.id}-efs"
}

resource "aws_security_group_rule" "testefs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.server.id
  security_group_id        = aws_security_group.testefs.id
}

