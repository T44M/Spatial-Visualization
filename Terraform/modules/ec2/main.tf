resource "aws_instance" "grafana_influxdb" {
  ami           = "ami-xxxxxxxxxxxxxxxxx" # 自分のami IDを入れる
  instance_type = "t2.micro"

  key_name = aws_key_pair.ec2_ssh_key.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "GrafanaInfluxDB"
  }
}

resource "aws_key_pair" "ec2_ssh_key" {
  key_name   = "ec2_ssh_key"
  public_key = file("~/.ssh/id_rsa.pub") # 自分のkeyを入れる
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow inbound connections for Grafana, InfluxDB, and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
