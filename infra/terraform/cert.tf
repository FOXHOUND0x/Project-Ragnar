resource "aws_acm_certificate" "ragnar_cert" {
    domain_name = "ragnar.the0x.dev"
    validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "validate_ragnar" {
    depends_on = [ aws_acm_certificate.ragnar_cert ]
    certificate_arn = aws_acm_certificate.ragnar_cert.arn
    validation_record_fqdns = var.cert_fqdns
}

resource "aws_acm_certificate" "cli_cert" {
    domain_name = "cli.the0x.dev"
    validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "validate_cli" {
    depends_on = [ aws_acm_certificate.cli_cert ]
    certificate_arn = aws_acm_certificate.cli_cert.arn
    validation_record_fqdns = var.cert_fqdns_cli
}
