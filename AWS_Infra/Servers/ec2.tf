resource "aws_instance" "webserver" {
  ami                    = "ami-0759f51a90924c166"
  instance_type          = "t2.micro"
  key_name = "demo-kp"
  vpc_security_group_ids = [aws_security_group.web-sg-01.id]
#  user_data              = "${file("userdata_web.sh")}"
  subnet_id              = var.public_sn
    associate_public_ip_address = true

  tags = {
    Name  = "Web-01"
    Owner = "Terraform"
  }
}

/*
resource "aws_instance" "app-server" {
  ami                    = "ami-0759f51a90924c166"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg-01.id]
  subnet_id              = aws_subnet.private-sn.id

  tags = {
    Name  = "app-01"
    Owner = "Terraform"
  }
}
*/
#Security Group Resource to open port 80 
resource "aws_security_group" "web-sg-01" {
  name        = "Web-SG-01"
  description = "Web-SG-01"
  vpc_id      = var.web_sg

  ingress {
    description      = "Port 80 from Everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "ssh from Everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    description      = "Port 80 from Everywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  # ipv6_cidr_blocks = ["::/0"]
  }
}

/*
output "public_ip" {
  value = aws_instance.webserver.public_ip
}

output "private_ip" {
  value = aws_instance.app-server.public_ip
}
*/