resource "aws_vpc" "public" {
    cidr_block       = var.public-vpc-net
    instance_tenancy = "default"

    tags = {
        Name = "vpc-public"
    }
}
resource "aws_internet_gateway" "public-igw" {
    vpc_id = aws_vpc.public.id

    tags = {
        Name = "public-igw"
    }
}
resource "aws_subnet" "public1" {
    vpc_id     = aws_vpc.public.id
    cidr_block = var.public1-subnet

    tags = {
        Name = "subnet-public1"
    }
}


resource "aws_vpc" "public-bastion" {
    cidr_block       = var.public-bastion-vpc
    instance_tenancy = "default"

    tags = {
        Name = "vpc-public-bastion"
    }
}
resource "aws_subnet" "public-bastion" {
    vpc_id     = aws_vpc.public-bastion.id
    cidr_block = var.public-bastion-subnet

    tags = {
        Name = "subnet-public-bastion"
    }
}

resource "aws_internet_gateway" "public-bastion-igw" {
    vpc_id = aws_vpc.public-bastion.id

    tags = {
        Name = "public-bastion-igw"
    }
}

resource "aws_route_table" "public-bastion-route" {
    vpc_id = aws_vpc.public-bastion.id

    tags = {
        Name = "public-bastion-route"
    }
}
resource "aws_route" "bastion-to-inet" {
    route_table_id = aws_route_table.public-bastion-route.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public-bastion-igw.id
}
resource "aws_route" "bastion-to-private" {
    route_table_id = aws_route_table.public-bastion-route.id
    destination_cidr_block = var.private-vpc-net
    vpc_peering_connection_id = aws_vpc_peering_connection.bastion-to-private.id
}
resource "aws_route_table_association" "public-bastion" {
    subnet_id      = aws_subnet.public-bastion.id
    route_table_id = aws_route_table.public-bastion-route.id
}


resource "aws_vpc" "private1" {
    cidr_block       = var.private-vpc-net
    instance_tenancy = "default"

    tags = {
        Name = "vpc-private1"
    }
}
resource "aws_internet_gateway" "private-igw" {
    vpc_id = aws_vpc.private1.id

    tags = {
        Name = "private-igw"
    }
}

resource "aws_subnet" "private-a" {
    availability_zone = "us-east-1a"
    vpc_id     = aws_vpc.private1.id
    cidr_block = var.private-a-subnet

    tags = {
        Name = "subnet-private-a"
    }
}
resource "aws_subnet" "private-b" {
    availability_zone = "us-east-1b"
    vpc_id     = aws_vpc.private1.id
    cidr_block = var.private-b-subnet

    tags = {
        Name = "subnet-private-b"
    }
}
resource "aws_subnet" "private-c" {
    availability_zone = "us-east-1c"
    vpc_id     = aws_vpc.private1.id
    cidr_block = var.private-c-subnet

    tags = {
        Name = "subnet-private-c"
    }
}

resource "aws_route_table" "private1-route" {
    vpc_id = aws_vpc.private1.id
    tags = {
        Name = "private1-route"
    }
}
resource "aws_route" "private-to-bastion" {
    route_table_id = aws_route_table.private1-route.id
    destination_cidr_block = var.public-bastion-subnet
    vpc_peering_connection_id = aws_vpc_peering_connection.bastion-to-private.id
}

resource "aws_route" "private-to-inet" {
    route_table_id = aws_route_table.private1-route.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.private-igw.id
}

resource "aws_route_table_association" "private-a" {
    subnet_id      = aws_subnet.private-a.id
    route_table_id = aws_route_table.private1-route.id
}
resource "aws_route_table_association" "private-b" {
    subnet_id      = aws_subnet.private-b.id
    route_table_id = aws_route_table.private1-route.id
}
resource "aws_route_table_association" "private-c" {
    subnet_id      = aws_subnet.private-c.id
    route_table_id = aws_route_table.private1-route.id
}





resource "aws_vpc_peering_connection" "bastion-to-private" {
    peer_owner_id = var.account_id
    peer_vpc_id   = aws_vpc.private1.id
    vpc_id        = aws_vpc.public-bastion.id
    peer_region   = var.region
    tags = {
        Name = "Bastion-to-Private"
    }
}