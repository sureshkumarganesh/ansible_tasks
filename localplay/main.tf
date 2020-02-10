provider "aws" {
  region = "us-east-2"
}
resource "aws_key_pair" "depl" { 
  key_name = "nkeyy"
  public_key = "${file("/home/ec2-user/.ssh/id_rsa.pub")}"
}
resource "aws_instance" "playbook" {
  ami = "ami-0520e698dd500b1d1"
  instance_type = "t2.micro"
  key_name = "nkeyy"
  tags = {
    Name = "new"

  }

provisioner "local-exec" {
  
  command = "echo ${self.private_ip} > inventory"
 
}
provisioner "remote-exec" {
  inline = ["echo connectionestablished"]
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("/home/ec2-user/.ssh/id_rsa")}"
    host = "${self.private_ip}"
   
  }
 
 }
provisioner "local-exec" {
  command = "ansible-playbook -i /home/ec2-user/suresh/localplay/inventory  -u ec2-user /home/ec2-user/suresh/localplay/play.yml"
}

}
