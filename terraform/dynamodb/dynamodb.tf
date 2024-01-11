resource "aws_dynamodb_table" "youtube_link" {
  name           = "youtube-link"
  table_class    = "STANDARD"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  hash_key       = "id"
  range_key      = "name"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }
}
