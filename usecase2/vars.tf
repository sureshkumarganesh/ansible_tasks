variable "ami_id" {
     type = "list"
    default = ["ami-0520e698dd500b1d1","ami-0520e698dd500b1d1"]
}
variable "instance_type" {

    default = "t2.micro"
  
}

variable "availability_zone" {
    type = "list"
    default = ["us-east-2a","us-east-2b"]
}

variable "tag_name" {
    type = "list"
    default = ["web","db"]
}

variable "key_name" {
    type = "list"
    default = ["webkey","dbkey"]
}


  





