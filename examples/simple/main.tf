data "aws_availability_zones" "this" {
  state = "available"
}

module "ctx" {
  source  = "git::https://github.com/chiwooiac/tfmodule-context.git"
  context = {
    aws_profile  = "terran"
    region       = "ap-northeast-2"
    project      = "stdecs"
    environment  = "Development"
    owner        = "owener@demonow.io"
    team         = "DevOps"
    cost_center  = "20211120"
    domain       = "demonow.io"
    pri_domain   = "demonow.local"
  }
}

module "vpc" {
  source = "../../"

  context = module.ctx.context

  cidr = "${var.vpc_cidr}.0.0/16"

  azs = [data.aws_availability_zones.this.zone_ids[0], data.aws_availability_zones.this.zone_ids[1]]
  public_subnets       = ["${var.vpc_cidr}.11.0/24", "${var.vpc_cidr}.12.0/24"]
  public_subnet_names  = ["pub-a1", "pub-b1"]
  public_subnet_suffix = "pub"
  public_subnet_tags   = {
    "kubernetes.io/cluster/${module.ctx.name_prefix}-eks" = "shared"
    "kubernetes.io/role/elb"                              = 1
  }
  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnets      = [
    "${var.vpc_cidr}.31.0/24", "${var.vpc_cidr}.32.0/24",
    "${var.vpc_cidr}.41.0/24", "${var.vpc_cidr}.42.0/24",
    "${var.vpc_cidr}.51.0/24", "${var.vpc_cidr}.52.0/24",
  ]

  private_subnet_names = [
    "waf-a1", "waf-c1",
    "ecs-a1", "ecs-c1",
    "fargate-a1", "fargate-c1",
  ]

  private_subnet_tags = {
    "kubernetes.io/cluster/${module.ctx.name_prefix}-eks" = "shared"
    "kubernetes.io/role/internal-elb"                     = 1
  }

  database_subnets       = ["${var.vpc_cidr}.91.0/24", "${var.vpc_cidr}.92.0/24"]
  database_subnet_names  = ["data-a1", "data-c1"]
  database_subnet_suffix = "data"
  database_subnet_tags   = { "grp:Name" = "${module.ctx.name_prefix}-data" }

  depends_on = [module.ctx]
}