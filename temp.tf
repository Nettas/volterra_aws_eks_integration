resource "volterra_origin_pool" "frontend" {
  name                   = format("%s-frontend", var.base)
  namespace              = volterra_namespace.ns.name
  depends_on             = [time_sleep.ns_wait]
  description            = format("Origin pool pointing to frontend k8s service running in main-vsite")
  loadbalancer_algorithm = "ROUND ROBIN"
  origin_servers {
    k8s_service {
      inside_network  = false
      outside_network = false
      vk8s_networks   = true
      service_name    = format("frontend.%s", volterra_namespace.ns.name)
      site_locator {
        virtual_site {
          name      = volterra_virtual_site.main.name
          namespace = volterra_namespace.ns.name
        }
      }
    }
  }
  port               = 80
  no_tls             = true
  endpoint_selection = "LOCAL_PREFERRED"
}