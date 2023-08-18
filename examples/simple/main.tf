data "aws_availability_zones" "this" {
  state = "available"
}

module "ctx" {
  source  = "git::https://github.com/chiwooiac/tfmodule-context.git"
  context = {
    region      = "ap-northeast-2"
    project     = "simple"
    environment = "Development"
    owner       = "admin@symplesims.io"
    team        = "DevOps"
    cost_center = "20211120"
    domain      = "symplesims.io"
    pri_domain  = "symplesims.local"
  }
}

module "vpc" {
  source               = "../../"
  context              = module.ctx.context
  cidr                 = "10.76.0.0/16"
  azs                  = [data.aws_availability_zones.this.zone_ids[0], data.aws_availability_zones.this.zone_ids[1]]
  public_subnets       = ["10.76.11.0/24", "10.76.12.0/24"]
  public_subnet_names  = ["pub-a1", "pub-b1"]
  public_subnet_suffix = "pub"
  public_subnet_tags   = {
    "kubernetes.io/cluster/${module.ctx.name_prefix}-eks" = "shared"
    "kubernetes.io/role/elb"                              = 1
  }
  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnets = [
    "10.76.31.0/24", "10.76.32.0/24",
    "10.76.41.0/24", "10.76.42.0/24",
    "10.76.51.0/24", "10.76.52.0/24",
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

  database_subnets       = ["10.76.91.0/24", "10.76.92.0/24"]
  database_subnet_names  = ["data-a1", "data-c1"]
  database_subnet_suffix = "data"
  database_subnet_tags   = { "grp:Name" = "${module.ctx.name_prefix}-data" }
}
