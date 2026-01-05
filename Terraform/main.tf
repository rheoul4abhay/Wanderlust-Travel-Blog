resource "aws_key_pair" "wanderlust-key_pair" {
  key_name   = "wanderlust-kp"
  public_key = file("/home/abhay/.ssh/gitops.pub")
}

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "wanderlust-sg" {
  name        = "allow TLS"
  description = "Allow users to connect"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "SSH Allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from anywhere
  }

  egress {
    description = "Allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NodePort Allow"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Redis Port Allow"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SMTPS"
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SMTP"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow development Ports"
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "Allow Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wanderlust-sg"
  }
}

resource "aws_instance" "wanderlust-master-ec2" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.wanderlust-key_pair.key_name
  security_groups = [aws_security_group.wanderlust-sg.name]
  tags = {
    Name = "wanderlust-master"
  }
  root_block_device {
    volume_size = 90
    volume_type = "gp3"
  }
}