resource "aws_ebs_volume" "example" {
  size              = 14
  availability_zone = "us-east-1a"
  tags = {
    Name = "HelloWorld 01"
  }
}
