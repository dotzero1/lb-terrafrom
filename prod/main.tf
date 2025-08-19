provider "aws" {
  region  = "us-west-2"
}

module "prod" {
  source              = "../env"
  environment         = "prod"
  load_balancer_count = 1

  domain_certificate_arn        = data.terraform_remote_state.global.outputs.cert_arn
  public_subnet_ids             = data.terraform_remote_state.prod.outputs.public_subnets
  vpc_id                        = data.terraform_remote_state.prod.outputs.vpc_id
}
