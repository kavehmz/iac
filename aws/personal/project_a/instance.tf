resource "aws_ebs_volume" "example" {
  count             = 1
  size              = 10
  availability_zone = "us-east-1a"
  tags = {
    Name = "HelloWorld 01"
  }
}
