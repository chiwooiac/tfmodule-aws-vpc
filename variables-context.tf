variable "context" {
  type = object({
    region       = string # describe default region to create a resource from aws
    region_alias = string # region alias or AWS
    project      = string # project name is usally account's project name or platform name
    environment  = string # Runtime Environment such as develop, stage, production
    env_alias    = string # Runtime Environment such as develop, stage, production
    owner        = string # project owner
    team         = string # Team name of Devops Transformation
    cost_center  = number # Cost Center
    name_prefix  = string # resource name prefix
    pri_domain   = string # private domain name (ex, tools.customer.co.kr)
    tags         = object({
      Project     = string
      Environment = string
      Team        = string
      Owner       = string
    })
  })
}