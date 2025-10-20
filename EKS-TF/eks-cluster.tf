module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "21.3.2"
  name    = local.cluster_name
# version = "~> 19.0" # Or a specific version like "19.14.0"
  kubernetes_version = "1.32"
# subnets         = module.vpc.private_subnets

# vpc_id = module.vpc.vpc_id
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access  = true
  endpoint_private_access = true
# public_access_cidrs     = ["0.0.0.0/0"]

  enable_cluster_creator_admin_permissions = true

  self_managed_node_groups = {
    jaseb-group-1 = {
      name                          = "jaseb-group-1"
      instance_type                 = "t2.small"
#     additional_userdata           = "echo foo bar"

# Required User Data for self-managed node groups
      additional_userdata = <<-EOT
        /etc/eks/bootstrap.sh ${local.cluster_name} --use-max-pods 20 --kubelet-extra-args '--node-labels=Name=${local.cluster_name}-worker'
      EOT
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      asg_desired_capacity          = 2
      root_volume_type              = "gp2"
      iam_instance_profile          = aws_iam_instance_profile.node_profile.name
    },
    jaseb-group-2 = {
      name                          = "jaseb-group-2"
      instance_type                 = "t2.medium"
#      additional_userdata           = "echo foo bar"
# Required User Data for self-managed node groups
      additional_userdata = <<-EOT
        /etc/eks/bootstrap.sh ${local.cluster_name} --use-max-pods 20 --kubelet-extra-args '--node-labels=Name=${local.cluster_name}-worker'
      EOT
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
      root_volume_type              = "gp2"
      iam_instance_profile          = aws_iam_instance_profile.node_profile.name
    },
  }
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
