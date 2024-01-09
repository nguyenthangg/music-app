resource "aws_s3_bucket" "file-resize-bucket-v2-21102000" {
  bucket = "file-resize-bucket-v2-21102000"

  tags = {
    Name        = "file resize v2 bucket"
    Environment = "stage"
  }
}