provider "aws" {
  region="us-east-2"

}

resource "aws_key_pair" "mykey" {
  count =  "${length(var.key_name)}"
  public_key = "${file("/home/ec2-user/.ssh/id_rsa.pub")}"
  key_name = "${element(var.key_name, count.index)}"
}

resource "aws_instance" "web" {
  count = "${length(var.availability_zone)}"
  ami = "${element(var.ami_id, count.index)}"
  instance_type = "${var.instance_type}"
  availability_zone = "${element(var.availability_zone, count.index)}"
  key_name = "${element(var.key_name, count.index)}"
  tags = {
  Name = "${element(var.tag_name, count.index)}"

 }
provisioner "remote-exec" {
 connection {
     type     = "ssh"
     user     = "ec2-user"
     private_key = "${file("/home/ec2-user/.ssh/id_rsa")}"
     host     = "${self.private_ip}"
   }

}
provisioner "local-exec" {
  connection {
     type     = "ssh"
     user     = "ec2-user"
     private_key = "${file("/home/ec2-user/.ssh/id_rsa")}"
     host     = "${self.private_ip}"
}

  command = <<EOF
   sudo echo -e "[group${count.index}]\n${self.public_ip} ansible_user=ec2-user ansible_connection=ssh ansible_private_key_file=/home/ec2-user/.ssh/id_rsa">>/etc/ansible/hosts        # Adding the private ip to the /etc/hosts file
   EOF
  }

  provisioner "local-exec" {
    command = "ansible-playbook -vv -i  /etc/ansible/hosts main_play.yml"
  }

}

output "instance_ips" {
  value = ["${aws_instance.web.*.public_ip}"]
}



