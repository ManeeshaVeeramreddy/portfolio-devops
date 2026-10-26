
variable "instance_id" {
  description = "ID of the existing portfolio EC2 instance"
  type        = string
}

data "aws_instance" "portfolio" {
  instance_id = var.instance_id
}

output "portfolio_instance_id" {
  value = data.aws_instance.portfolio.id
}

output "portfolio_instance_type" {
  value = data.aws_instance.portfolio.instance_type
}

output "portfolio_public_ip" {
  value = data.aws_instance.portfolio.public_ip
}

output "portfolio_state" {
  value = data.aws_instance.portfolio.instance_state
}
