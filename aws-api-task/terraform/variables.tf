# Input variable definitions

variable "myregion" {
  description = "AWS region for all resources."

  type    = string
  default = "eu-central-1"
}


variable "accountId" {
  description = "AWS account ID."

  type    = string
  default = "<Your account ID>"
}