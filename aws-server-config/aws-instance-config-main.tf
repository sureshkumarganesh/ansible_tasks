provider "aws"{
 region ="us-east-2"
}
resource "aws_instance" "web-server"{
  ami             = "ami-0520e698dd500b1d1"
  instance_type   = "t2.micro"
  key_name        = "awskey"
 
  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }
 
  provisioner "remote-exec"{
    inline = [
      "sudo yum install -y httpd;sudo cp /tmp/index.html /var/www/html/",
      "sudo service httpd restart",
      "sudo service httpd status"
     ]
  }
  connection {
    user        = "ec2-user"
    type        = "ssh"
    private_key = "${file("/home/ec2-user/.ssh/id_rsa")}"
    host        = "${aws_instance.web-server.public_ip}"
  }
}
