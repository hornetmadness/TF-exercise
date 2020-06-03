resource "aws_lb" "nginx-alb" {
    name               = "nginx-alb-tf"
    internal           = false
    load_balancer_type = "application"
    subnets            = [ aws_subnet.private-a.id, aws_subnet.private-b.id, aws_subnet.private-c.id ]

    enable_deletion_protection = false

    tags = {
        Name = "nginx-alb-tf"
    }
    depends_on = [
        aws_internet_gateway.public-igw,
        aws_subnet.private-a,
        aws_subnet.private-b,
        aws_subnet.private-c
    ]
}
resource "aws_lb_target_group" "nginx" {
    name     = "nginx"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.private1.id
}