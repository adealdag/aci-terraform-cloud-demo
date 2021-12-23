# Data Sources
data "aci_vmm_domain" "vmmdom" {
  provider_profile_dn = "uni/vmmp-VMware"
  name                = var.vmm_vcenter
}

# App Profile Definition
resource "aci_application_profile" "app_demo" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "test_app"
}

# EPG Definitions
resource "aci_application_epg" "web" {
  application_profile_dn = aci_application_profile.app_demo.id
  name                   = "web_epg"
  name_alias             = "Nginx"
  relation_fv_rs_cons = [aci_contract.web_to_app.id,
    aci_contract.any_to_log.id,
  aci_contract.inet_to_web.id]
  relation_fv_rs_bd = aci_bridge_domain.bd_192_168_1_0.id
}

resource "aci_epg_to_domain" "web_epg_domain" {
  application_epg_dn = aci_application_epg.web.id
  tdn                = data.aci_vmm_domain.vmmdom.id
}

resource "aci_application_epg" "app" {
  application_profile_dn = aci_application_profile.app_demo.id
  name                   = "app_epg"
  name_alias             = "NodeJS"
  relation_fv_rs_prov    = [aci_contract.web_to_app.id]
  relation_fv_rs_cons = [aci_contract.app_to_db.id,
    aci_contract.app_to_auth.id,
  aci_contract.any_to_log.id]
  relation_fv_rs_bd = aci_bridge_domain.bd_192_168_2_0.id
}

resource "aci_epg_to_domain" "app_epg_domain" {
  application_epg_dn = aci_application_epg.app.id
  tdn                = data.aci_vmm_domain.vmmdom.id
}

resource "aci_application_epg" "db_cache" {
  application_profile_dn = aci_application_profile.app_demo.id
  name                   = "db_cache_epg"
  name_alias             = "DB_Cache"
  relation_fv_rs_prov    = [aci_contract.app_to_db.id]
  relation_fv_rs_cons = [aci_contract.cache_to_db.id,
  aci_contract.any_to_log.id]
  relation_fv_rs_bd = aci_bridge_domain.bd_192_168_3_0.id
}

resource "aci_epg_to_domain" "dbcache_epg_domain" {
  application_epg_dn = aci_application_epg.db_cache.id
  tdn                = data.aci_vmm_domain.vmmdom.id
}

resource "aci_application_epg" "db" {
  application_profile_dn = aci_application_profile.app_demo.id
  name                   = "db_epg"
  name_alias             = "MariaDB"
  relation_fv_rs_prov    = [aci_contract.cache_to_db.id]
  relation_fv_rs_cons    = [aci_contract.any_to_log.id]
  relation_fv_rs_bd      = aci_bridge_domain.bd_192_168_3_0.id
}

resource "aci_epg_to_domain" "db_epg_domain" {
  application_epg_dn = aci_application_epg.db.id
  tdn                = data.aci_vmm_domain.vmmdom.id
}

resource "aci_application_epg" "log" {
  application_profile_dn = aci_application_profile.app_demo.id
  name                   = "log_epg"
  name_alias             = "Logstash"
  relation_fv_rs_prov    = [aci_contract.any_to_log.id]
  relation_fv_rs_bd      = aci_bridge_domain.bd_192_168_2_0.id
}

resource "aci_epg_to_domain" "log_epg_domain" {
  application_epg_dn = aci_application_epg.log.id
  tdn                = data.aci_vmm_domain.vmmdom.id
}

resource "aci_application_epg" "auth" {
  application_profile_dn = aci_application_profile.app_demo.id
  name                   = "auth_epg"
  name_alias             = "Auth"
  relation_fv_rs_prov    = [aci_contract.app_to_auth.id]
  relation_fv_rs_cons    = [aci_contract.any_to_log.id]
  relation_fv_rs_bd      = aci_bridge_domain.bd_192_168_2_0.id
}

resource "aci_epg_to_domain" "auth_epg_domain" {
  application_epg_dn = aci_application_epg.auth.id
  tdn                = data.aci_vmm_domain.vmmdom.id
}

resource "aci_any" "vzany" {
  vrf_dn                     = aci_vrf.main.id
  relation_vz_rs_any_to_cons = [aci_contract.any_to_dns.id]
}


# Contract Definitions
resource "aci_contract" "inet_to_web" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "inet_to_web_con"
  scope     = "tenant"
}

resource "aci_contract" "web_to_app" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "web_to_app_con"
  scope     = "tenant"
}

resource "aci_contract" "app_to_db" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "app_to_db_con"
  scope     = "tenant"
}

resource "aci_contract" "app_to_auth" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "app_to_auth_con"
  scope     = "tenant"
}

resource "aci_contract" "cache_to_db" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "cache_to_db_con"
  scope     = "tenant"
}

resource "aci_contract" "any_to_log" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "any_to_log_con"
  scope     = "tenant"
}

resource "aci_contract" "any_to_dns" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "any_to_dns_con"
  scope     = "tenant"
}

# Subject Definitions
resource "aci_contract_subject" "only_web_secure_traffic" {
  contract_dn                  = aci_contract.web_to_app.id
  name                         = "only_web_secure_traffic"
  relation_vz_rs_subj_filt_att = [aci_filter.https_traffic.id]
}

resource "aci_contract_subject" "only_icmp_traffic_to_app" {
  contract_dn                  = aci_contract.web_to_app.id
  name                         = "only_icmp_traffic"
  relation_vz_rs_subj_filt_att = [aci_filter.icmp_traffic.id]
}

resource "aci_contract_subject" "only_db_traffic" {
  contract_dn                  = aci_contract.app_to_db.id
  name                         = "only_db_traffic"
  relation_vz_rs_subj_filt_att = [aci_filter.db_traffic.id]
}

resource "aci_contract_subject" "only_icmp_traffic_to_db" {
  contract_dn                  = aci_contract.app_to_db.id
  name                         = "only_icmp_traffic"
  relation_vz_rs_subj_filt_att = [aci_filter.icmp_traffic.id]
}

resource "aci_contract_subject" "only_auth_traffic" {
  contract_dn                  = aci_contract.app_to_auth.id
  name                         = "only_auth_traffic"
  relation_vz_rs_subj_filt_att = [aci_filter.https_traffic.id]
}

resource "aci_contract_subject" "only_log_traffic" {
  contract_dn                  = aci_contract.any_to_log.id
  name                         = "only_log_traffic"
  relation_vz_rs_subj_filt_att = [aci_filter.https_traffic.id]
}

resource "aci_contract_subject" "only_db_cache_traffic" {
  contract_dn                  = aci_contract.cache_to_db.id
  name                         = "only_db_cache_traffic"
  relation_vz_rs_subj_filt_att = [aci_filter.db_traffic.id]
}

resource "aci_contract_subject" "any_to_dns_sbj" {
  contract_dn                  = aci_contract.any_to_dns.id
  name                         = "only_dns"
  relation_vz_rs_subj_filt_att = [aci_filter.dns_traffic.id]
}

resource "aci_contract_subject" "any_to_dns_icmp_sbj" {
  contract_dn                  = aci_contract.any_to_dns.id
  name                         = "only_icmp_traffic"
  relation_vz_rs_subj_filt_att = [aci_filter.icmp_traffic.id]
}

# Contract Filters
## HTTPS Traffic
resource "aci_filter" "https_traffic" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "https"
}

resource "aci_filter_entry" "https" {
  filter_dn = aci_filter.https_traffic.id
  name      = "https"
  ether_t   = "ip"
  prot      = "tcp"
  # Note using `443` here works, but is represented as `https` in the model
  # Using `https` prevents TF trying to set it to `443` every run
  d_from_port = "https"
  d_to_port   = "https"
}

## DB Traffic
resource "aci_filter" "db_traffic" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "mariadb"
}

resource "aci_filter_entry" "mariadb" {
  filter_dn   = aci_filter.db_traffic.id
  name        = "mariadb"
  ether_t     = "ip"
  prot        = "tcp"
  d_from_port = "3306"
  d_to_port   = "3306"
}

## DNS Traffic
resource "aci_filter" "dns_traffic" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "dns"
}

resource "aci_filter_entry" "dns_udp" {
  filter_dn   = aci_filter.dns_traffic.id
  name        = "dns_udp"
  ether_t     = "ip"
  prot        = "udp"
  d_from_port = "53"
  d_to_port   = "53"
}

resource "aci_filter_entry" "dns_tcp" {
  filter_dn   = aci_filter.dns_traffic.id
  name        = "dns_tcp"
  ether_t     = "ip"
  prot        = "tcp"
  d_from_port = "53"
  d_to_port   = "53"
}

## ICMP Traffic
resource "aci_filter" "icmp_traffic" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "icmp"
}

resource "aci_filter_entry" "icmp" {
  filter_dn = aci_filter.icmp_traffic.id
  name      = "icmp"
  ether_t   = "ip"
  prot      = "icmp"
}