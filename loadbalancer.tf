resource "aws_lb" "newtechload" {
  name               = "newtechloadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-web.id]
  subnets            = [aws_subnet.newtechprod-subnet.id, aws_subnet.newtechprod-subnet2.id]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.newtechlog.bucket
    prefix  = "newtech-sesendnewtech-logwtest-munklognewtechloadbalancerendmunkloadlog"
    enabled = true
  }

  tags = {
    Environment = "newtechproduction"
  }
}


# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "newtech_attachment" {
  autoscaling_group_name = aws_autoscaling_group.newtech.id
snewtechendmunk  alb_target_group_arn   = aws_lb_target_group.newtech.arn
}

resource "aws_lb_target_group" "newtech" {
  name     = "newtechalb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.newtechprod-vpc.id
}