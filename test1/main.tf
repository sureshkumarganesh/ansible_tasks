provider "aws" {
  region = "us-east-2"
}
resource "aws_key_pair" "depl" {
  key_name = "nkey"
  public_key = "${file("/home/ec2-user/.ssh/id_rsa.pub")}"
}
resource "aws_instance" "playbook" {
  count = 2
  ami = "${var.imageid}"
  availability_zone = "${element(var.availzone, count.index)}"
  instance_type = "t2.micro"
  key_name = "nkey"
  tags = {
    Name = "${element(var.awsname,count.index)}"
  }

 

  provisioner "local-exec" {
  command = "echo ${self.private_ip} ansible_user=ec2-user ansible_private_key_file=/home/ec2-user/.ssh/id_rsa > inventory"
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
  command = "ansible-playbook -i /home/ec2-user/terraform/new1/inventory  -u ec2-user /home/ec2-user/terraform/new1/playbook.yml"
  }
}
