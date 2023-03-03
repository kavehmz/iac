resource "aws_ebs_volume" "example" {
  size = 8

  tags = {
    Name = "HelloWorld 02"
  }
}
