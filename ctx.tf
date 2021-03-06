
resource "aci_filter" "allow_http" {
  tenant_dn = aci_tenant.demo.id
  name      = "allow_http"
}

resource "aci_filter" "allow_icmp" {
  tenant_dn = aci_tenant.demo.id
  name      = "allow_icmp"
}

resource "aci_filter_entry" "http" {
  name        = "http"
  filter_dn   = aci_filter.allow_http.id
  ether_t     = "ip"
  prot        = "tcp"
  d_from_port = "http"
  d_to_port   = "http"
  stateful    = "yes"
}

resource "aci_filter_entry" "icmp" {
  name      = "http"
  filter_dn = aci_filter.allow_icmp.id
  ether_t   = "ip"
  prot      = "icmp"
  stateful  = "yes"
}

resource "aci_contract" "contract_web_app" {
  tenant_dn = aci_tenant.demo.id
  name      = "web"
}

resource "aci_contract_subject" "web_subject1" {
  contract_dn                  = aci_contract.contract_web_app.id
  name                         = "Subject"
  relation_vz_rs_subj_filt_att = [aci_filter.allow_http.id, aci_filter.allow_icmp.id]
}
