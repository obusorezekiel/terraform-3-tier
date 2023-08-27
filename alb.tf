resource "aws_lb" "web-tier-lb" {
    name = "web-tier-lb" 
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.web-tier-lb-sg.id]
    subnets = [aws_subnet.public_subnet_1.id ,aws_subnet.public_subnet_2.id]

    tags = {
        Name = "Pub-Sub-ALB"
    }
}

resource "aws_lb_target_group" "web-tier-tg" {
    name = "web-tier-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main_vpc.id

    health_check {
        interval = 60
        path     = "/"
        port     = 80
        timeout  = 45
        protocol = "HTTP"
        matcher  = "200,202"
    }
}

resource "aws_lb_listener" "web-tier-alb-listener" {
    load_balancer_arn = aws_lb.web-tier-lb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.web-tier-tg.arn
    }
}

resource "aws_lb" "app-tier-lb" {
    name = "app-tier-lb" 
    internal = true
    load_balancer_type = "application"
    security_groups = [aws_security_group.app-tier-sg.id]
    subnets = [aws_subnet.private_subnet-1.id ,aws_subnet.private_subnet-2.id]

    tags = {
        Name = "Priv-Sub-ALB"
    }
}

resource "aws_lb_target_group" "app-tier-tg" {
    name = "app-tier-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main_vpc.id
}

resource "aws_lb_listener" "app-tier-alb-listener" {
    load_balancer_arn = aws_lb.app-tier-lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app-tier-tg.arn
    }
}



