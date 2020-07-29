provider "aws"
{
	region = "us-east-1"
}

resource "aws_instance" "example"
{
        ami           = "ami-0a0ddd875a1ea2c7f"
	key_name      = "temp_key"
	instance_type = "t2.micro" 
	availability_zone = "us-east-1c"
        security_groups = ["${aws_security_group.ec2.name}"]
        user_data = <<-EOF
                    #!/bin/bash
                    sudo apt update -y 
                    sudo apt install nginx -y
                    echo "“Cisco SPL”" > /var/www/html/index.html
                    sudo systemctl enabled nginx.service
                    sudo systemctl start nginx.service
                    EOF
    tags =
      {
        Name = "terraform-webserver"
      }

}
resource "aws_elb" "example" {
    name               = "example"
    availability_zones = ["us-east-1c"]
    listener {
       instance_port     = 80
       instance_protocol = "http"
       lb_port           = 80
       lb_protocol       = "http"
             }
    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:80/"
        interval            = 10
            }
   instances                   = ["${aws_instance.example.id}"]
   idle_timeout                = 400
   connection_draining         = true
   connection_draining_timeout = 400
   tags =
        {
        Name = "terraform-webserver"
        }

}

resource "aws_security_group" "ec2"
{
    name = "ec2"
    description = "securitygroup"
    ingress
	{
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
	}
     ingress
	{
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
	}
     ingress
	{
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
	}
	egress
	{
	  from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
	}
}

/* Enable if autoscaling is required
resource "aws_autoscaling_group" "example" 
   {
    name                      = "terraform-test"
    availability_zones        = ["us-east-1c","us-east-1b"]
    max_size                  = 4
    min_size                  = 2
    health_check_grace_period = 300
    health_check_type         = "ELB"
    force_delete              = true
    launch_configuration      = "${aws_launch_configuration.example.name}"
  }

resource "aws_launch_configuration" "example"
    {
        image_id         = "ami-0a0ddd875a1ea2c7f"
	key_name         = "temp_key"
	instance_type    = "t2.micro" 		
        security_groups = ["${aws_security_group.ec2.name}"]
        user_data = <<-EOF
                    #!/bin/bash
                    sudo apt update -y 
                    sudo apt install nginx -y
                    echo "“Cisco SPL”" > /var/www/html/index.html
                    sudo systemctl enabled nginx.service
                    sudo systemctl start nginx.service
                    EOF
        lifecycle {
            create_before_destroy = true
        }
}
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.example.id}"
  elb                    = "${aws_elb.example.id}"
}
*/

output "subnet_id"
{
	value = "${aws_instance.example.subnet_id}"
}
output "vpc_id"
{
	value = "${aws_security_group.ec2.vpc_id}"
}
output "elb_dns"
{
	value = "${aws_elb.example.dns_name}"
}
