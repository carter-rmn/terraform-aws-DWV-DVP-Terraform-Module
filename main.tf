module "ecr" {
  count = var.ecr.create ? 1 : 0
  source                      = "./modules/ecr"
  ecrname_builder             = var.ecr.ecrname_builder
  ecrname_management          = var.ecr.ecrname_management
  ecrname_connector           = var.ecr.ecrname_connector
  ecrname_fe                  = var.ecr.ecrname_fe
  ecrname_test_builder        = var.ecr.ecrname_test_builder
  ecrname_test_management     = var.ecr.ecrname_test_management
  ecrname_test_connector      = var.ecr.ecrname_test_connector 
  ecrname_test_fe             = var.ecr.ecrname_test_fe
  imagetag                    = var.ecr.imagetag
  ecrname_odin                = var.ecr.ecrname_odin
  ecrname_web                 = var.ecr.ecrname_web
  ecrname_scheduler           = var.ecr.ecrname_scheduler
  ecrname_odin_executor_rmn   = var.ecr.ecrname_odin_executor_rmn
  ecrname_odin_web_rmn        = var.ecr.ecrname_odin_web_rmn 
  ecrname_odin_scheduler_rmn  = var.ecr.ecrname_odin_scheduler_rmn
}
module "eks" {
  count = var.eks.create ? 1 : 0
  source                = "./modules/eks"
  environment           = var.eks.environment
  cluster_name          = var.eks.cluster_name
  private_id            = module.vpc.private_subnets
  fargate_namespace_1   = var.eks.fargate_namespace_1
  fargate_namespace_2   = var.eks.fargate_namespace_2
  fargate_namespace_3   = var.eks.fargate_namespace_3
  fargate_namespace_4   = var.eks.fargate_namespace_4
  fargate_namespace_5   = var.eks.fargate_namespace_5
  eks_role_name         = var.eks.eks_role_name
  aws_eks_cluster_version = var.eks.aws_eks_cluster_version
  depends_on            = [module.vpc]
}

module "ec2-instance" {
  count = var.ec2-instance.create ? 1 : 0
  source              = "./modules/ec2-instance"
  instance_name_1     = var.ec2-instance.instance_name_1
  instance_name_2     = var.ec2-instance.instance_name_2
  instance_type       = var.ec2-instance.instance_type
  instance_ami        = var.ec2-instance.instance_ami
  key_name            = var.ec2-instance.key_name
  vpc_security_group_ids = module.eks.eks_sg
  subnet_id           = module.vpc.public_subnets[0]
  filename            = var.ec2-instance.filename
  bucket_name         = var.ec2-instance.bucket_name
  volume_size         = var.ec2-instance.volume_size
  volume_type         = var.ec2-instance.volume_type


}
module "data-weaver-ec2-instance" {
  count = var.data-weaver-ec2-instance.create ? 1 : 0
  source = "./modules/data-weaver-ec2-instance"
  instance_name_odin  = var.data-weaver-ec2-instance.instance_name
  instance_type_odin  = var.data-weaver-ec2-instance.instance_type
  instance_ami_odin   = var.data-weaver-ec2-instance.ami
  subnet_id_odin          = module.vpc.public_subnets[1]
  key_name_odin             = var.data-weaver-ec2-instance.key_name
  volume_size_odin          = var.data-weaver-ec2-instance.volume_size
  volume_type_odin         = var.data-weaver-ec2-instance.volume_type
  vpc_security_group_ids     = var.data-weaver-ec2-instance.security_group_id
  ebs_name = var.data-weaver-ec2-instance.ebs_name
  instance_profile     = var.data-weaver-ec2-instance.instance_profile
  project_name    = local.dev-odin-infra.project_name
  PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
  PROJECT_ENV = var.PROJECT_ENV 
  depends_on         = [module.ecs]
  
}
module "ecs" {
  count = var.ecs.create ? 1 : 0
  source                = "./modules/ecs"
  container_name        =  var.ecs.container_name
  ecs_sg                = var.ecs.ecs_sg
  load_balancer         = var.ecs.load_balancer
  targate_group         = var.ecs.targate_group
  vpc_id                = var.ecs.vpc_id
  ecr_web_url           = module.ecr.ecr_web_url
  certificate_arn       = var.ecs.certificate_arn
  eks_sg                = var.ecs.eks_sg
  api-gateway-name = var.ecs.api-gateway-name
  security_group_ids = module.eks.eks_sg
  subnet_ids = module.vpc.private_subnets
  stage-name = var.ecs.stage-name
  domain_name = var.ecs.domain_name
  hosted_zone_id = var.ecs.hosted_zone_id
  vpc-link-name = var.ecs.vpc-link-name
  private_subnet        = var.ecs.private_subnet
  ecr_url               = module.ecr.ecr_url
#   task_definition       =  var.task_definition 
#   ecs_cluster           =  var.ecs_cluster 
#   ecs_service           = var.ecs_service
  
#   odin_ecs_service_web  = var.odin_ecs_service_web
#   container_name_web    = var.container_name_web
#   task_definition_web   = var.task_definition_web
#   task_definition_scheduler  = var.task_definition_scheduler
#   container_name_scheduler  = var.container_name_scheduler
#   ecr_scheduler_url      = module.ecr.ecr_scheduler_url
#   odin_ecs_service_scheduler = var.odin_ecs_service_scheduler
#   APPLICATION_NAME_SCHEDULER   = var.APPLICATION_NAME_SCHEDULER
#   BEAT_CRON_SCHEDULER    = var.BEAT_CRON_SCHEDULER
  #privatesubnet_b        = var.privatesubnet_b
  #privatesubnet_c        = var.privatesubnet_c
#   APPLICATION_NAME      = var.APPLICATION_NAME
#   KAFKA_CONSUMER_GROUP_ID = var.KAFKA_CONSUMER_GROUP_ID
#   KAFKA_JOB_TOPIC        = var.KAFKA_JOB_TOPIC
#   KAFKA_BOOTSTRAP_SERVERS = var.KAFKA_BOOTSTRAP_SERVERS
#   MONGODB_DATABASE       = var.MONGODB_DATABASE
#   MONGODB_PORT           = var.MONGODB_PORT
#   MONGODB_HOST           = var.MONGODB_HOST
#   MONGODB_URI            = var.MONGODB_URI
#   BEAT_CRON              = var.BEAT_CRON
#   APPLICATION_NAME_WEB   = var.APPLICATION_NAME_WEB
#   SERVER_PORT            = var.SERVER_PORT
#   SEGMENT_DB_URL         = var.SEGMENT_DB_URL
#   SEGMENT_DB_USERNAME    = var.SEGMENT_DB_USERNAME
#   SEGMENT_DB_PASSWORD    = var.SEGMENT_DB_PASSWORD
#   ODIN_STORAGE_DB_URL    = var.ODIN_STORAGE_DB_URL  
#   ODIN_STORAGE_DB_PASSWORD  = var.ODIN_STORAGE_DB_PASSWORD
#   ODIN_STORAGE_DB_USERNAME  = var.ODIN_STORAGE_DB_USERNAME
#   MONGODB_DATAWEAVER_URI    = var.MONGODB_DATAWEAVER_URI
#   MONGODB_DATAWEAVER_DATABASE   = var.MONGODB_DATAWEAVER_DATABASE
#   ENCRYPTION_ALGORITHM      = var.ENCRYPTION_ALGORITHM
#   ENCRYPTION_KEY          = var.ENCRYPTION_KEY
#   KILL_FLOWS_TOPIC        = var.KILL_FLOWS_TOPIC
#   S3_SEGMENT_CSV_BUCKET   = var.S3_SEGMENT_CSV_BUCKET
#   AWS_ACCESS_KEY          = var.AWS_ACCESS_KEY
#   AWS_SECRET_KEY          = var.AWS_SECRET_KEY
#   AWS_REGION              = var.AWS_REGION
  depends_on            = [module.ecr, module.vpc, module.eks]

}

module "msk" {
    count = var.msk.create ? 1 : 0
    source = "./modules/msk"
    # msk       = var.msk
    # private_subnet     = var.private_subnet
    security_group  = var.msk.security_group
    kafka_cluster      = var.msk.msk_cluster
    subnet_ids         = module.vpc.private_subnets
    # kafka_version      = var.kafka_version
    number_of_broker_nodes = var.msk.number_of_broker_nodes
    kafka_instance_type = var.msk.instance_type
    kafka_volume_size = var.msk.volume_size
    kafka_cloudwatch_log_group = var.msk.msk_cloudwatch_log_group
    project_name    = local.dev-odin-infra.project_name
    PROJECT_CUSTOMER    = var.PROJECT_CUSTOMER
    PROJECT_ENV = var.PROJECT_ENV 
    kafka_config = var.msk.msk_config
    depends_on         = [module.ecs]  
}
module "rds" {
    count = var.rds.create ? 1 : 0
    source = "./modules/rds"
    db_name     = var.rds.db_name
    engine      = var.rds.engine
    engine_version = var.rds.engine_version
    identifier   = var.rds.identifier
    instance_class = var.rds.instance_class
    username   = var.rds.username
    password   = var.rds.password
    parameter_group_name  = var.rds.parameter_group_name
    db_subnet_group = var.rds.db_subnet_group
    ecs_sg   = var.rds.security_group
    subnet_ids = module.vpc.private_subnets
    rds_allocated_storage = var.rds.rds_allocated_storage
    rds_max_allocated_storage = var.rds.rds_max_allocated_storage
    # rds_storage_type = var.rds_storage_type
    # rds_iops   = var.rds_iops
    rds_backup_retention_period = var.rds.rds_backup_retention_period
    # rds_backup_window = var.rds_backup_window
    # rds_maintenance_window = var.rds_maintenance_window
    depends_on = [module.vpc]
}
module "s3" {
     count = var.s3.create ? 1 : 0
     source = "./modules/s3"
     bucket_name_1 = var.s3.bucket_name_1
}

module "redis" {
    count = var.redis.create ? 1 : 0
    source = "./modules/redis"
    redis_sg    =   var.redis.redis_sg 
    redis_name   =  var.redis.redis_name
    redis_engine_version    =   var.redis.redis_engine_version
    redis_node    =   var.redis.redis_node
    redis_num_shards    =   var.redis.redis_num_shards 
    redis_num_replicas_per_shard    =   var.redis.redis_num_replicas_per_shard 
    eks_sg   =   var.redis.eks_sg
    redis_snapshot_retention_limit    =   var.redis.redis_snapshot_retention_limit
    subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
    depends_on = [module.vpc]
}

module "api-gateway" {
  count = var.api-gateway.create ? 1 : 0
  source = "./modules/api-gateway"
  odin_rmn_web_certificate_arn = var.api-gateway.odin_rmn_web_certificate_arn
  odin-rmn-stage-name = var.api-gateway.odin-rmn-stage-name
  odin-rmn-api-gateway-name = var.api-gateway.odin-rmn-api-gateway-name
  odin_rmn_domain_name = var.api-gateway.odin_rmn_domain_name
  hosted_zone_id = var.api-gateway.hosted_zone_id
  odin-rmn-vpc-link-name = var.api-gateway.odin-rmn-vpc-link-name
  odi_rmn_alb_listener_arn = var.api-gateway.odi_rmn_alb_listener_arn
  security_group_ids = module.eks.eks_sg
  subnet_ids = module.vpc.private_subnets
  depends_on            = [module.vpc, module.eks]

}

module "secrets-manager" {
  count = var.secrets-manager.create ? 1 : 0
  source = "./modules/secrets-manager"
  secret_name = var.secrets-manager.secret_name
  secret_string = module.data-weaver-ec2-instance.private_key_data_weaver

}