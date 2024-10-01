variable "cert_fqdns" {
    type = list(string)
    default = ["_e734927429226a143895e15c951616c5.ragnar.the0x.dev."]
}

variable "cert_fqdns_cli" {
    type = list(string)
    default = ["_ec97d71e66556d82c3621ffb95a40435.cli.the0x.dev."]
}

variable "cert_domain" {
    type = string
    default = "ragnar.the0x.dev"
}

variable "cert_zone_id" {
    type = string
    default = "the0x_dev"
}

variable "cert_zone_name" {
    type = string
    default = "the0x.dev"
}

variable "CLOUDFLARE_API_TOKEN" {
    type = string
}

variable "CLOUDFLARE_ZONE_ID" {
    type = string
}