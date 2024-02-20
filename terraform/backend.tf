terraform {
  backend "s3" {
    bucket         = "file-store-file-tfstate"
    key            = "staging/statefile.tfstate"
    region         = "us-west-2"
    encrypt        = true
    
  }
}
