resource "aws_security_group" "bastion" {
    name        = "bastion"
    description = "Allow SSH inbound traffic from the Internet to bastion"
    vpc_id      = aws_vpc.public-bastion.id

    tags = {
        Name = "bastion"
    }
}
resource "aws_security_group_rule" "bastion-inet-ssh-ingress" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.bastion.id
    cidr_blocks = [ "0.0.0.0/0"]
}
resource "aws_security_group_rule" "bastion-egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.bastion.id
    cidr_blocks = [ "0.0.0.0/0"]
}



resource "aws_security_group" "webservers" {
    name        = "webservers"
    description = "Allow HTTP inbound traffic from the Internet"
    vpc_id      = aws_vpc.public.id

    tags = {
        Name = "webservers"
    }
}
resource "aws_security_group_rule" "allow-inet-http-ingress" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = aws_security_group.webservers.id
    cidr_blocks = [ "0.0.0.0/0"]
}
resource "aws_security_group_rule" "webservers-egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.webservers.id
    cidr_blocks = [ "0.0.0.0/0"]
}




# resource "aws_security_group" "allow-private-bastion-ssh" {
#   name        = "allow-bastion-ssh"
#   description = "Allow SSH inbound traffic from the bastion hosts"
#   vpc_id      = aws_vpc.private1.id

#   tags = {
#     Name = "allow_bastion_ssh"
#   }
# }
# resource "aws_security_group_rule" "allow-private-bastion-ssh-ingress" {
#     type = "ingress"
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     security_group_id = aws_security_group.allow-private-bastion-ssh.id
#     cidr_blocks = [ var.public-bastion-subnet ]
# }




resource "aws_security_group" "allow-private-http" {
    name        = "allow-private-http"
    description = "Allow HTTP inbound traffic from private space"
    vpc_id      = aws_vpc.private1.id

    tags = {
      Name = "allow_inet_http"
    }
}
resource "aws_security_group_rule" "allow-ssh-from-bastion-ingress" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.allow-private-http.id
    cidr_blocks = [ var.public-bastion-subnet ]
}
resource "aws_security_group_rule" "allow-private-http-ingress" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = aws_security_group.allow-private-http.id
    cidr_blocks = [ var.private-a-subnet, var.private-b-subnet, var.private-c-subnet ]
}
resource "aws_security_group_rule" "allow-private-http-egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.allow-private-http.id
    cidr_blocks = [ "0.0.0.0/0"]
}