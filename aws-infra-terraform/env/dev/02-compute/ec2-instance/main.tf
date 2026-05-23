data "terraform_remote_state" "networking" {

  backend = "s3"

  config = {

    bucket = "sentinel-dev-terraform-state-bucket"

    key = "dev/networking/terraform.tfstate"

    region = "ap-south-1"
  }
}

#################################
# LABELS
#################################

module "labels" {

  source = "../../../../modules/labels"

  project     = var.project
  environment = var.environment
}

module "ec2_instances" {
  source = "../../../../modules/compute/ec2-instance"

  for_each = var.instances

  instance_name = "${module.labels.prefix}-${each.key}"

  ami_id        = each.value.ami_id
  instance_type = each.value.instance_type

  subnet_id = data.terraform_remote_state.networking.outputs.subnet_ids[each.value.subnet_key]

  security_group_ids = [data.terraform_remote_state.networking.outputs.security_group_id]

  key_name = try(each.value.key_name, null)

  associate_public_ip_address = try(each.value.associate_public_ip_address, false)

  volume_size = each.value.volume_size

  volume_type = each.value.volume_type

  encrypted = each.value.encrypted

  delete_on_termination = each.value.delete_on_termination

  tags = module.labels.common_tags
}