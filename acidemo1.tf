# https://github.com/datacenter/DEVWKS-1334/blob/master/Terraform%20Workshop%20Guide.md

provider "aci" {
  # cisco-aci user name
  username = var.username
  # cisco-aci password
  password = var.password
  # cisco-aci url
  url      = var.url
  insecure = true
}

resource "aci_tenant" "demo" {
  name      = var.tenantName
  }

resource "aci_vrf" "vrf" {
  tenant_dn = aci_tenant.demo.id
  name      = var.vrfName
  }

resource "aci_application_profile" "ap" {
  tenant_dn = aci_tenant.demo.id
  name      = var.apName
  }

# WEB EPG
resource "aci_bridge_domain" "bd_web" {
  tenant_dn             = aci_tenant.demo.id
  relation_fv_rs_ctx    = aci_vrf.vrf.id
  name                  = var.bdWeb
  }

resource "aci_subnet" "bd_web_subnet" {
  parent_dn = aci_bridge_domain.bd_web.id
  ip        = var.bdWebSubnet
  scope     = ["shared"]
}

resource "aci_application_epg" "epgweb" {
  application_profile_dn    = aci_application_profile.ap.id
  name                      = var.epgWeb
  relation_fv_rs_bd         = aci_bridge_domain.bd_web.id
  }

resource "aci_epg_to_domain" "vmm_web" {
  application_epg_dn = aci_application_epg.epgweb.id
  tdn                = data.aci_vmm_domain.vds.id
}

resource "aci_epg_to_contract" "webctx" {
  application_epg_dn = aci_application_epg.epgweb.id
  contract_dn = aci_contract.contract_web_app.id
  contract_type = "consumer"
}

# APP EPG
resource "aci_application_epg" "epgapp" {
  application_profile_dn    = aci_application_profile.ap.id
  name                      = var.epgApp
  relation_fv_rs_bd         = aci_bridge_domain.bd_app.id
  }

resource "aci_bridge_domain" "bd_app" {
  tenant_dn             = aci_tenant.demo.id
  relation_fv_rs_ctx    = aci_vrf.vrf.id
  name                  = var.bdApp
  }

resource "aci_subnet" "bd_app_subnet" {
  parent_dn = aci_bridge_domain.bd_app.id
  ip        = var.bdAppSubnet
  scope     = ["shared"]
}

resource "aci_epg_to_domain" "vmm_app" {
  application_epg_dn = aci_application_epg.epgapp.id
  tdn                = data.aci_vmm_domain.vds.id
}

resource "aci_epg_to_contract" "appctx" {
  application_epg_dn = aci_application_epg.epgapp.id
  contract_dn = aci_contract.contract_web_app.id
  contract_type = "provider"
}