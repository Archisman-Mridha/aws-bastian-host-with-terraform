resource "aws_eip" "this" {
  vpc = true

  depends_on = [
    aws_internet_gateway.this
  ]
}

resource "aws_nat_gateway" "this" {
  subnet_id     = aws_subnet.public_subnet.id
  allocation_id = aws_eip.this.id
}
