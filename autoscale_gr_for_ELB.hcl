#Purpose: Create an auto-scaling group linked to an Elastic Load Balancer.

provider "aws" {
  region = "us-east-1"
}

resource "aws_launch_configuration" "web" {
  name          = "web-launch-configuration"
  image_id      = "ami-0abcd1234efgh5678"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "web" {
  launch_configuration = aws_launch_configuration.web.id
  min_size             = 2
  max_size             = 5
  vpc_zone_identifier  = ["subnet-12345678", "subnet-87654321"]

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}

resource "aws_elb" "web" {
  name               = "web-elb"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

output "elb_dns_name" {
  value = aws_elb.web.dns_name
}
