module "ec2_instances" {
  source = "../../../../modules/compute/ec2-instance"

  for_each = var.instances

  instance_name = each.key

  ami_id        = each.value.ami_id
  instance_type = each.value.instance_type

  subnet_id = each.value.subnet_id

  security_group_ids = each.value.security_group_ids

  key_name = try(each.value.key_name, null)

  associate_public_ip_address = try(each.value.associate_public_ip_address, false)

  volume_size = each.value.volume_size

  volume_type = each.value.volume_type

  encrypted = each.value.encrypted

  delete_on_termination = each.value.delete_on_termination

  tags = var.tags
}