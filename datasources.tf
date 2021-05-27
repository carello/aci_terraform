data "aci_vmm_domain" "vds" {
  provider_profile_dn = "uni/vmmp-VMware"
  name                = var.vmwareDomain
}
