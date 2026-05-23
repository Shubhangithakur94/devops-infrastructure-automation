resource "aws_instance" "ec2_instance" {

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = var.security_group_ids

  associate_public_ip_address = var.associate_public_ip_address

  key_name = var.key_name

  root_block_device {

    volume_size = var.volume_size

    volume_type = var.volume_type

    encrypted = var.encrypted

    delete_on_termination = var.delete_on_termination
  }

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )
}