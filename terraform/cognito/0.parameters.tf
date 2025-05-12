variable "domain_prefix" {
  type        = string
  description = "The prefix in the domain for token endpoints e.g. https://{prefix}.auth.eu-central.amazoncognito.com/oauth2/token"
  default     = "car-rental"
}
