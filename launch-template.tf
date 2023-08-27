resource "aws_launch_template" "web-tier-lt" {
    name = "web-tier-lt"
    image_id               = "ami-0f409bae3775dc8e5"
    instance_type          = "t2.micro"
    key_name               = "ec2-key"
    vpc_security_group_ids = [aws_security_group.web-tier-lb-sg.id]
    user_data              = filebase64("${path.root}/install-apache.sh")
}

resource "aws_autoscaling_group" "web-tier-asg" {
    name = "web-tier-asg"
    min_size = 1
    max_size = 4
    desired_capacity = 1
    vpc_zone_identifier = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

    launch_template {
        id = aws_launch_template.web-tier-lt.id
  }
}

resource "aws_autoscaling_attachment" "asg-web-attach" {
    autoscaling_group_name = aws_autoscaling_group.web-tier-asg.id
    lb_target_group_arn    = aws_lb_target_group.web-tier-tg.arn
}

resource "aws_launch_template" "app-tier-lt" {
    name = "app-tier-lt"
    image_id               = "ami-0f409bae3775dc8e5"
    instance_type          = "t2.micro"
    key_name               = "ec2-key"
    vpc_security_group_ids = [aws_security_group.app-tier-sg.id]
    user_data              = filebase64("${path.root}/install-apache.sh")
}

resource "aws_autoscaling_group" "app-tier-asg" {
    name = "app-tier-asg"
    min_size = 1
    max_size = 4
    desired_capacity = 1
    vpc_zone_identifier = [aws_subnet.private_subnet-1.id, aws_subnet.private_subnet-2.id]

    launch_template {
        id = aws_launch_template.app-tier-lt.id
  }
}

resource "aws_autoscaling_attachment" "asg-app-attach" {
    autoscaling_group_name = aws_autoscaling_group.app-tier-asg.id
    lb_target_group_arn    = aws_lb_target_group.app-tier-tg.arn
}
