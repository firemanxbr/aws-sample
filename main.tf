#module "s3" {
#  source = "./modules/s3" 
#}

module "network" {
  source                  = "./modules/network"
  cluster_name            = "eks-cluster"
  iac_environment_tag     = "development"
  name_prefix             = "aws-sample"
  main_network_block      = "10.0.0.0/16"
  subnet_prefix_extension = 4
  zone_offset             = 8
}

module "eks" {
  source                                   = "./modules/eks"
  admin_users                              = ["eks-admin"]
  developer_users                          = ["eks-read-only"]
  asg_instance_types                       = ["t3.small", "t2.small"]
  autoscaling_minimum_size_by_az           = 1
  autoscaling_maximum_size_by_az           = 2
  autoscaling_average_cpu                  = 70
  spot_termination_handler_chart_name      = "aws-node-termination-handler"
  spot_termination_handler_chart_repo      = "https://aws.github.io/eks-charts"
  spot_termination_handler_chart_version   = "0.9.1"
  spot_termination_handler_chart_namespace = "kube-system"
}

module "iam" {
  source      = "./modules/iam"
}

module "namespaces" {
  source      = "./modules/namespaces"
  namespaces  = ["sample-apps"]
}

module "ingress" {
  source                        = "./modules/ingress"
  # new feature in development (domain support)
  dns_base_domain               = "eks.firemanxbr.org"
  ingress_gateway_chart_name    = "nginx-ingress"
  ingress_gateway_chart_repo    = "https://helm.nginx.com/stable"
  ingress_gateway_chart_version = "0.5.2"
  ingress_gateway_annotations   = {
    "controller.service.httpPort.targetPort"                                                                    = "http",
    "controller.service.httpsPort.targetPort"                                                                   = "http",
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"        = "http",
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"               = "https",
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout" = "60",
    "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"                    = "elb"
  }
}