# -- compute/main.tf ---
data "aws_ami" "server_ami" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}

# create random string to our instance

resource "random_id" "peter_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "peter_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "peter_node" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id
  tags = {
    Name = "peter-${random_id.peter_node_id[count.index].dec}"
  }
  key_name               = aws_key_pair.peter_auth.id
  vpc_security_group_ids = var.public_sg
  subnet_id              = var.public_subnets[count.index]
  user_data = templatefile(
    var.user_data_path,
    {
      nodename    = "peter_node_${random_id.peter_node_id[count.index].dec}"
      db_endpoint = var.db_endpoint
      dbuser      = var.dbuser
      dbpass      = var.dbpassword
      dbname      = var.dbname
    }
  )
  root_block_device {
    volume_size = var.vol_size
  }
}

