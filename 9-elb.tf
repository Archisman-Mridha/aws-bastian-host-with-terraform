resource "aws_elb" "this" {
  subnets = [aws_subnet.private_subnet.id]

  security_groups = [aws_security_group.elb.id]

  listener {
    lb_port     = 6443
    lb_protocol = "TCP"

    instance_port     = 6443
    instance_protocol = "TCP"
  }

  internal                  = false
  cross_zone_load_balancing = true

  idle_timeout                = 300
  connection_draining         = false
  connection_draining_timeout = 300

  health_check {
    target = "SSL:6443"

    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5

    interval = 10
  }
}
