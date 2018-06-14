resource "aws_instance" "aws-app-discourse-01" {
  ami           = "${data.aws_ami.ubuntu-1604.id}"
  instance_type = "t2.micro"
  key_name = "aws-key-discourse"
  availability_zone = "us-east-1a"
  vpc_security_group_ids = ["${aws_security_group.aws-sg-dscourse.id}"]
  tags {
    Name = "aws-app-discourse"
  }
}

resource "aws_ebs_volume" "aws-ebs-discourse-01" {
    availability_zone = "${aws_instance.aws-app-discourse-01.availability_zone}"
    size = 8 
    tags {
        Name = "aws-ebs-discourse-01"
    }
}

resource "aws_volume_attachment" "aws-attachment-discourse-01" {
  device_name = "/dev/xvdb"
  instance_id = "${aws_instance.aws-discourse-01.id}"
  volume_id   = "${aws_ebs_volume.aws-ebs-discourse-01.id}"
}

resource "aws_security_group" "aws-sg-discourse" {
  name = "aws-sg-discourse"
  description = "security group for discourse"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

