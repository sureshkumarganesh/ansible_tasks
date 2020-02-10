provider "aws" {
  region  = "us-east-2"
}
resource "aws_instance" "web"{
 ami   = "ami-0520e698dd500b1d1"
 availbility_zone = "us-ease-2a"
 instance_type    = "t2.micro"
 key_name         = "awskey"
 tags={
   Name = "New_with_ans_play"
 }
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("/home/ec2-user/.ssh/id_rsa")}"
    host     = "${self.public_ip}"
  }
provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
}
provisioner "file" {
     source      = ""
     destination = ""
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

 
