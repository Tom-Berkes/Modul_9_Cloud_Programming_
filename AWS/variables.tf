variable "region" {
  default = "eu-central-1"
}

variable "bucket_name_prefix" {
  default = "hello-world-website"
}

variable "index_document" {
  default = "index.html"
}

variable "tags" {
  type = map(string)
  default = {
    Name        = "StaticWebsite"
    Environment = "demo"
    Owner       = "Tom Berkes"
  }
}

variable "cloudfront_enabled" {
  type    = bool
  default = true
}

