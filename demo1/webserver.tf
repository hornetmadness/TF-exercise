resource "random_id" "server" {
    keepers = {
        # Generate a new id each time we switch to a new AMI id
        ami_id = var.nginx-ami
        sg-rule=aws_security_group.allow-private-http.id
    }
    byte_length = 8
}


resource "aws_launch_configuration" "nginx-lc" {
    name          = "nginx-lc-${random_id.server.hex}"
    associate_public_ip_address = false
    image_id      = var.nginx-ami
    instance_type = "t2.micro"
    security_groups = [ aws_security_group.allow-private-http.id ]
    key_name = aws_key_pair.erik.key_name
    placement_tenancy = "default"
}

resource "aws_autoscaling_group" "nginx-asg" {
    name                 = "nginx-asg"
    availability_zones = var.webserver-az
    launch_configuration = aws_launch_configuration.nginx-lc.name
    desired_capacity   = 1
    min_size             = 1
    max_size             = 1

    # target_group_arns = [ data.aws_lb_target_group.nginx ]

    lifecycle {
        create_before_destroy = true
    }
    vpc_zone_identifier = [ aws_subnet.private-a.id, aws_subnet.private-b.id, aws_subnet.private-c.id ]
}