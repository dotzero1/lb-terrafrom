## OUTPUTS ##
output "listener_arns" {
  description = "Map of the listener arns"
  value = module.prod.listener_arns
}

output "alb_dns_names" {
  description = "Map of ALB DNS names with predictable keys"
  value = module.prod.alb_dns_names
}

output "alb_zone_ids" {
  description = "Map of ALB zone IDs with predictable keys"
  value = module.prod.alb_zone_ids
}
