output "private_dns_zone_ids" {
  value = {
    container_registry = module.private_dns.zone_ids["container_registry"]
  }
}