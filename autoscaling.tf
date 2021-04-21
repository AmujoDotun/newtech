resource "aws_launch_template" "newtech" {
  name_prefix   = "newtechauto"
  image_id      = "ami-0f99334f233722245"
  instance_type = "t2.2xlarge"
  key_name      = "${var.key_name}"

}

resource "aws_autoscaling_group" "newtech" {
#   launch_configuration = aws_launch_template.newtech.id
#   availability_zones = ["us-east-2a"]
  desired_capacity   = 1
  max_size           = 5
  min_size           = 1
  vpc_zone_identifier = [aws_subnet.newtechprod-subnet.id, aws_subnet.newtechprod-subnet2.id]

  launch_template {
    id      = aws_launch_template.newtech.id
    version = "$Latest"

  }
}