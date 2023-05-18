/* resource "aws_elb" "elb" {
  availability_zones = [var.aws_zone]

  listener {
    lb_port     = 6443
    lb_protocol = "TCP"

    instance_port     = 6443
    instance_protocol = "TCP"
  }

  instances = [aws_instance.master_node.id]

  internal                  = false
  cross_zone_load_balancing = false
} */
