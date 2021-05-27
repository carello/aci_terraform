# https://github.com/datacenter/DEVWKS-1334/blob/master/Terraform%20Workshop%20Guide.md
# https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs

resource "aci_tenant" "demo" {
  name = var.tenantName
}

resource "aci_vrf" "vrf01" {
  tenant_dn = aci_tenant.demo.id
  name      = var.vrf01Name
}

resource "aci_application_profile" "ap1" {
  tenant_dn = aci_tenant.demo.id
  name      = var.ap01Name
}

# ---- WEB EPG ----
resource "aci_bridge_domain" "bd_web" {
  tenant_dn          = aci_tenant.demo.id
  relation_fv_rs_ctx = aci_vrf.vrf01.id
  name               = var.bdWeb
}

resource "aci_subnet" "bd_web_subnet" {
  parent_dn = aci_bridge_domain.bd_web.id
  ip        = var.bdWebSubnet
  scope     = ["private"]
}

resource "aci_application_epg" "epg_web" {
  application_profile_dn = aci_application_profile.ap1.id
  name                   = var.epgWeb
  relation_fv_rs_bd      = aci_bridge_domain.bd_web.id
}

resource "aci_epg_to_domain" "vmm_web" {
  application_epg_dn = aci_application_epg.epg_web.id
  tdn                = data.aci_vmm_domain.vds.id
}

resource "aci_epg_to_contract" "web_ctx" {
  application_epg_dn = aci_application_epg.epg_web.id
  contract_dn        = aci_contract.contract_web_app.id
  contract_type      = "consumer"
}

# ---- APP EPG ----
resource "aci_bridge_domain" "bd_app" {
  tenant_dn          = aci_tenant.demo.id
  relation_fv_rs_ctx = aci_vrf.vrf01.id
  name               = var.bdApp
}

resource "aci_subnet" "bd_app_subnet" {
  parent_dn = aci_bridge_domain.bd_app.id
  ip        = var.bdAppSubnet
  scope     = ["private"]
}

resource "aci_application_epg" "epg_app" {
  application_profile_dn = aci_application_profile.ap1.id
  name                   = var.epgApp
  relation_fv_rs_bd      = aci_bridge_domain.bd_app.id
}

resource "aci_epg_to_domain" "vmm_app" {
  application_epg_dn = aci_application_epg.epg_app.id
  tdn                = data.aci_vmm_domain.vds.id
}

resource "aci_epg_to_contract" "app_ctx" {
  application_epg_dn = aci_application_epg.epg_app.id
  contract_dn        = aci_contract.contract_web_app.id
  contract_type      = "provider"
}

