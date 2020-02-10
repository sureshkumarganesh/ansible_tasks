#AWS_ANS_SERV_INTSALL_AND_START_HTTPD

provider "aws" {
  region  = "us-east-2"
}
resource "aws_key_pair" "terraform_demo" {
  key_name   = "terra_key"
  public_key = "${file("/home/ec2-user/.ssh/id_rsa.pub")}"
}
resource "aws_instance" "web" {
  count      = 2
  ami        = "ami-0520e698dd500b1d1"
  availability_zone = "${element(var.azs,count.index)}"
  instance_type     = "t2.micro"
  key_name            = "terra_key"
  tags = {
    Name    = "${element(var.tags,count.index)}"
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("/home/ec2-user/.ssh/id_rsa")}"
    host     = "${self.public_ip}"
  }
  provisioner "local-exec" {
     command = "echo ${self.private_ip} >> private_ips_${count.index}.txt"
  }
  provisioner "file" {
     source      = "script.sh"
     destination = "/home/ec2-user/scripts.sh"
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = "${file("/home/ec2-user/.ssh/id_rsa")}"
      host     = "${self.public_ip}"
    }

    inline = [
      "chmod +x scripts.sh",
      "sudo ./scripts.sh << ENDOFFILE"
    ]
  }
}

