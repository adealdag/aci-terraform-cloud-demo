### Tenant Definition
resource "aci_tenant" "terraform_tenant" {
  name = "tf_demo_test_tn"
}

### Networking Definition

# VRF
resource "aci_vrf" "main" {
  tenant_dn = aci_tenant.terraform_tenant.id
  name      = "main_vrf"
}

# Bridge Domains
resource "aci_bridge_domain" "bd_192_168_1_0" {
  tenant_dn                = aci_tenant.terraform_tenant.id
  name                     = "192.168.1.0_24_bd"
  relation_fv_rs_ctx       = aci_vrf.main.id
  relation_fv_rs_bd_to_out = [module.core_l3out.id]
}

resource "aci_subnet" "subnet_192_168_1_1" {
  parent_dn = aci_bridge_domain.bd_192_168_1_0.id
  ip        = "192.168.1.1/24"
  scope     = ["public"]
}

resource "aci_bridge_domain" "bd_192_168_2_0" {
  tenant_dn          = aci_tenant.terraform_tenant.id
  name               = "192.168.2.0_24_bd"
  relation_fv_rs_ctx = aci_vrf.main.id
}

resource "aci_subnet" "subnet_192_168_2_1" {
  parent_dn = aci_bridge_domain.bd_192_168_2_0.id
  ip        = "192.168.2.1/24"
  scope     = ["private"]
}

resource "aci_bridge_domain" "bd_192_168_3_0" {
  tenant_dn          = aci_tenant.terraform_tenant.id
  name               = "192.168.3.0_24_bd"
  relation_fv_rs_ctx = aci_vrf.main.id
}

resource "aci_subnet" "subnet_192_168_3_1" {
  parent_dn = aci_bridge_domain.bd_192_168_3_0.id
  ip        = "192.168.3.1/24"
  scope     = ["private"]
}

# L3Out
data "aci_l3_domain_profile" "core" {
  name = "core_l3dom"
}

module "core_l3out" {
  source = "github.com/adealdag/terraform-aci-l3out?ref=v0.2.0"

  name      = "core_l3out"
  tenant_dn = aci_tenant.terraform_tenant.id
  vrf_dn    = aci_vrf.main.id
  l3dom_dn  = data.aci_l3_domain_profile.core.id

  bgp = {
    enabled = true
  }

  nodes = {
    "1101" = {
      pod_id             = "1"
      node_id            = "1101"
      router_id          = "1.1.1.101"
      router_id_loopback = "no"
    },
    "1102" = {
      pod_id             = "1"
      node_id            = "1102"
      router_id          = "1.1.1.102"
      router_id_loopback = "no"
    }
  }

  interfaces = {
    "1101_1_25" = {
      l2_port_type     = "port"
      l3_port_type     = "sub-interface"
      pod_id           = "1"
      node_a_id        = "1101"
      interface_id     = "eth1/25"
      ip_addr_a        = "172.16.23.10/30"
      vlan_encap       = "vlan-23"
      vlan_encap_scope = "local"
      mode             = "regular"
      mtu              = "9216"

      bgp_peers = {
        "key" = {
          peer_ip_addr     = "172.16.23.9"
          peer_asn         = "65020"
          addr_family_ctrl = "af-ucast"
          bgp_ctrl         = "send-com,send-ext-com"
        }
      }
    },
    "1102_1_25" = {
      l2_port_type     = "port"
      l3_port_type     = "sub-interface"
      pod_id           = "1"
      node_a_id        = "1102"
      interface_id     = "eth1/25"
      ip_addr_a        = "172.16.23.14/30"
      vlan_encap       = "vlan-23"
      vlan_encap_scope = "local"
      mode             = "regular"
      mtu              = "9216"

      bgp_peers = {
        "key" = {
          peer_ip_addr     = "172.16.23.13"
          peer_asn         = "65020"
          addr_family_ctrl = "af-ucast"
          bgp_ctrl         = "send-com,send-ext-com"
        }
      }
    }
  }

  external_l3epg = {
    "default" = {
      name         = "default"
      pref_gr_memb = "exclude"
      subnets = {
        "default" = {
          prefix = "0.0.0.0/0"
          scope  = ["import-security"]
        }
      }
      cons_contracts = [aci_contract.inet_to_web.id]
    }
  }
}

