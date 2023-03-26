provider "aws" {
  region = "your_region"
}

locals {
  common_tags = {
    Project = "RaspberryPi-EnvironmentMonitoring"
  }
}

module "iot_core" {
  source = "./modules/iot_core"
}

module "lambda" {
  source = "./modules/lambda"
}

module "ec2" {
  source = "./modules/ec2"
}
