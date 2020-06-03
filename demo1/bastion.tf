resource "aws_instance" "bastion1" {
    ami                         = var.bastion-ami
    instance_type               = "t2.micro"
    associate_public_ip_address = true

    subnet_id = aws_subnet.public-bastion.id
    vpc_security_group_ids = [ aws_security_group.bastion.id ]

    key_name = aws_key_pair.erik.key_name

    tags = {
        Name = "bastion-host1"
    }
}

# module "web_server_sg" {
#   source = "terraform-aws-modules/security-group/aws//modules/http-80"

#   name        = "web-server"
#   description = "Security group for web-server with HTTP ports open within VPC"
#   vpc_id      = "vpc-12345678"

#   ingress_cidr_blocks = ["10.10.0.0/16"]
# }

output "bastion_public_ip" {
    value = aws_instance.bastion1.public_ip
}