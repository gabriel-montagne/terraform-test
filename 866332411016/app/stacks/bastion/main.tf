data "aws_ami" "amazon_linux_2" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "bastion_ltemplate" {
  name = "bastion-${var.dtap}"
  update_default_version = true

  image_id = data.aws_ami.amazon_linux_2.id

  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.bastion.id]
  }

  user_data = base64encode(trimspace(
<<EOF
#!/bin/bash
echo '${join("\n", var.authorized_keys)}' >> /home/ec2-user/.ssh/authorized_keys
EOF
   ))

  tags = {
    Terraform = "true"
    Environment = var.dtap
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion-${var.dtap}-2"
  description = "Bastion host ${var.dtap}"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Terraform = "true"
    Environment = var.dtap
  }
}

resource "aws_instance" "bastion_host" {
  lifecycle {
    ignore_changes = [user_data]
  }

  launch_template {
    id      = aws_launch_template.bastion_ltemplate.id
    version = "$Latest"
  } 
  instance_type   = "t3.micro"
  subnet_id        = var.public_subnet_ids[0]

  tags = {
    Name = "bastion-${var.dtap}-2"
    Terraform = "true"
    Environment = var.dtap
  }
}
