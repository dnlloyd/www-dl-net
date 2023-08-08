resource "aws_cloudfront_origin_access_control" "www" {
  name                              = "www"
  description                       = "Allow access from daniel-lloyd.net"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_origin_access_identity" "www" {}

resource "aws_cloudfront_distribution" "www" {
  enabled = true
  comment = "www-daniel-lloyd-net"
  default_root_object = "index.html"
  aliases = ["www.daniel-lloyd.net"]

  viewer_certificate {
    ssl_support_method = "sni-only"
    acm_certificate_arn = "arn:aws:acm:us-east-1:166865586247:certificate/26fa6dbf-c34f-4590-8006-dae62cbdd1d9"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin {
    domain_name = aws_s3_bucket.www.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.www.id
    origin_id = "s3-dl-net"

    s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.www.cloudfront_access_identity_path
      }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-dl-net"

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    viewer_protocol_policy = "redirect-to-https"
  }
}
