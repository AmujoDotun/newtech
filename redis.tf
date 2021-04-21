
resource "aws_elasticache_cluster" "newtechRedis" {
  cluster_id           = "newtechredisid"
  engine               = "redis"
  node_type            = "cache.m4.xlarge"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
}