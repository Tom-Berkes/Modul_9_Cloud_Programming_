output "website_url" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}

output "cdn_url" {
  value = aws_cloudfront_distribution.cdn[0].domain_name
  description = "URL der CloudFront-Distribution"
}
