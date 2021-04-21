
provider "aws" {
  region = "us-east-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

# 1. Create vpc

resource "aws_vpc" "newtechprod-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "newtechproduction"
  }
}

# 2. Create Internet gateway

resource "aws_internet_gateway" "newtechgw" {
  vpc_id = aws_vpc.newtechprod-vpc.id

}

# 3. Create Custom Route Table

resource "aws_route_table" "newtechprod-route-table" {
  vpc_id = aws_vpc.newtechprod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.newtechgw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.newtechgw.id
  }

  tags = {
    Name = "newtechProd"
  }
}


# 4. Create a Subnet
resource "aws_subnet" "newtechprod-subnet" {
  vpc_id = aws_vpc.newtechprod-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    "Name" = "prod-subnet"
  }
}

# 4. Create a Subnet2
resource "aws_subnet" "newtechprod-subnet2" {
  vpc_id = aws_vpc.newtechprod-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    "Name" = "prod-subnet2"
  }
}

# 5. Associate subnet with Route Table

resource "aws_route_table_association" "newtecha" {
  subnet_id      = aws_subnet.newtechprod-subnet.id
  route_table_id = aws_route_table.newtechprod-route-table.id
}

# 6. Create Security Group to allow port 22,80,443

resource "aws_security_group" "allow-web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.newtechprod-vpc.id


  ingress {
    description = "mysql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_WEB"
  }
}

# 7. Create a network interface with an ip oin the subnet that was created in steop4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.newtechprod-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow-web.id]

}

# 8. assign an elastiv IpO to the network interface created in step 7
resource "aws_eip" "newtechip" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.newtechgw]
}



resource "aws_instance" "newtech-instance" {
  ami = "ami-0f99334f233722245"
  instance_type = "t2.2xlarge"
  availability_zone = "us-east-2a"
  key_name = "newtechpair"
  # associate_public_ip_address = true

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }



#   associate_public_ip_address = true




  user_data = <<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install nginx -y
            sudo systemctl start nginx
            sudo systemctl enable nginx
            EOF

    tags = {
      "Name" = "newtech-server"
    }
}

resource "aws_security_group" "allowrds" {
  name        = "allowrds_traffic"
  description = "Allow rds inbound traffic"
  vpc_id      = var.rds_vpc_id


  ingress {
    description = "mysql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}