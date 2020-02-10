variable "azs" {
  type = "list"
  default = ["us-east-2a","us-east-2b"]
}
variable "instance_count" {
  default = "2"
}
variable "tags" {
  type = "list"
  default = ["terraform_rhel","terraform_amazon2"]
}

