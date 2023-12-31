resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "main"
    }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet"
    }

}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet-1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = false

}

resource "aws_subnet" "private_subnet-2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = false
}

resource "aws_subnet" "private_subnet-3" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.5.0/24"
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = false

}

resource "aws_subnet" "private_subnet-4" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.6.0/24"
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "main_vpc"
  }
}

resource "aws_eip" "ngw-eip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "terraform-ngw" {
    allocation_id = aws_eip.ngw-eip.id
    subnet_id = aws_subnet.public_subnet_1.id

    tags = {
        Name = "Igw NAT"
    }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main_igw]
}




