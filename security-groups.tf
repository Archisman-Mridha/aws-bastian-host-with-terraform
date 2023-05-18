resource "aws_security_group" "bastian_host" {
  name = "bastian-host"

  vpc_id = aws_vpc.this.id

  // In production scenarios, the Bastian Host can be accessed only from the IPs you
  // have allowed. But for simplicity, I am keeping it accessible from anywhere.
  ingress {
    description = "Allow access from anywhere"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cluster" {
  name = "cluster"

  vpc_id = aws_vpc.this.id

  ingress {
    description = "Allow complete access to the nodes from only the Bastian Host"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb" {
  name = "elb"

  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
