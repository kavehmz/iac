resource "aws_ebs_volume" "example" {
  count             = 1
  sie               = 8
  availability_zone = "us-east-1a"
  tags = {
        Name = "HelloWorld 01"
  }
}
