terraform {
    backend "s3" {
      bucket = "ezekiel-terra-state"
      key = "terraform.tfstate"
      region = "us-east-1"
    }
    
}