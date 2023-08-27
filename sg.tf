resource "aws_security_group" "web-tier-lb-sg" {
    name = "web-tier-sg"
    description = "SG for web-tier-lb"
    vpc_id = aws_vpc.main_vpc.id 

    ingress {
        description = "ssh from vpc" 
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "http from vpc" 
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "https from vpc" 
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "web-tier sg"
  }
}

resource "aws_security_group" "app-tier-sg" {
    name = "app-tier-sg"
    description = "SG for app-tier-lb"
    vpc_id = aws_vpc.main_vpc.id 

    ingress {
        description = "ssh from vpc" 
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.web-tier-lb-sg.id]
    }

    ingress {
        description = "http from vpc" 
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.web-tier-lb-sg.id]
    }

    ingress {
        description = "https from vpc" 
        from_port = 443
        to_port = 443
        protocol = "tcp"
        security_groups = [aws_security_group.web-tier-lb-sg.id]
    }

    ingress {
        description = "Allow all incoming IPv4 traffic"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        security_groups = [aws_security_group.web-tier-lb-sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "app-tier sg"
  }
}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app-tier-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.app-tier-sg.id]
  }
}
