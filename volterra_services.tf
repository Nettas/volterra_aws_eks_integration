############################ Volterra Origin Pool (eks service ClusterIP) ###########################
resource "volterra_origin_pool" "app" {
  name                   = nginx-eks-web
  namespace              = var.volterra_namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  no_tls                 = true

  origin_servers {
    k8s_service {
      inside_network  = false
      outside_network = true
      vk8s_networks   = false
      service_name    = var.service_name
      site_locator {
        site {
          tenant      = var.tenant_name
          name        = volterra_aws_vpc_site.name
          namespace   = "system"
        }
      }
    }
  }
}

############################ Volterra WAF#########################
resource "volterra_waf" "waf" {
  name        = var.waf
  description = "block mode"
  namespace   = var.volterra_namespace
  mode = "BLOCK"
}

############################ Volterra HTTP LB ############################

resource "volterra_http_loadbalancer" "service" {
  for_each                        = local.business_units
  name                            = format("%s-%s-app-%s", var.projectPrefix, each.key, var.buildSuffix)
  namespace                       = var.namespace
  no_challenge                    = true
  domains                         = var.delegated_dns_domain
  random                          = true
  disable_rate_limit              = true
  service_policies_from_namespace = true
  disable_waf                     = true

  advertise_custom {
    advertise_where {
      port = 80
      virtual_site {
        network = "SITE_NETWORK_INSIDE"
        virtual_site {
          name      = var.volterraVirtualSite
          namespace = var.namespace
          tenant    = var.volterraTenant
        }
      }
    }
  }

  default_route_pools {
    pool {
      name = volterra_origin_pool.app[each.key].name
    }
  }

  http {
    dns_volterra_managed = false
  }
}