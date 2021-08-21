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

resource "volterra_http_loadbalancer" "eks_service_nginx_app" {
  name                            = "nginx-eks-web"
  namespace                       = var.volterra_namespace
  depends_on                      = [time_sleep.ns_wait]
  description                     = "LB for EKS service"
  domains                         = [var.app_fqdn]
  advertise_on_public_default_vip = true
  labels                          = { "ves.io/app_type" = volterra_app_type.at.name }
  default_route_pools {
    pool {
      name      = volterra_origin_pool.app.name
      namespace = var.volterra_namespace
    }
  }
  https_auto_cert {
    add_hsts      = false
    http_redirect = true
    no_mtls       = true
  }
  waf {
    name      = volterra_waf.waf.name
    namespace = var.volterra_namespace
  }
  disable_waf                     = false
  disable_rate_limit              = true
  round_robin                     = true
  service_policies_from_namespace = true
  no_challenge                    = true
}