terraform {
  backend "s3" {
    bucket = "dotzero-tf-prod"
    key    = "loadbalancers/terraform.tfstate"
    region = "us-west-2"

    use_lockfile = true
  }
}

data "terraform_remote_state" "prod" {
  backend = "s3"

  config = {
    bucket = "dotzero-tf-prod"
    key    = "tf/terraform.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket = "dotzero-tfstate-global"
    key    = "tf/terraform.tfstate"
    region = "us-west-2"
  }
}
