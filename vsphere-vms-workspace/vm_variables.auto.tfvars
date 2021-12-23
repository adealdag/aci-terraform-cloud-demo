aci_app_info = {
  app_name    = "demo_app"
  tenant_name = "ndo_demo_tn"
}

vm_location = {
  "mdr1" = {
    domain_name       = "dcmdr.ciscolabs.com"
    vsphere_cluster   = "HX-C1"
    vsphere_dc        = "MDR1"
    vsphere_ds        = "HX-DS01"
    vsphere_vm_folder = "adealdag/tfc-demo"
  },
  "mlg1" = {
    domain_name       = "dcmdr.ciscolabs.com"
    vsphere_cluster   = "UCS-C1"
    vsphere_dc        = "MLG1"
    vsphere_ds        = "UCS-C1-DS01"
    vsphere_vm_folder = "adealdag/tfc-demo"
  }
}

vm_list = {
  "ngnix01" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-ngnix-01"
    vm_network_ip      = "192.168.1.101"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.1.1"
    vm_epg_name        = "web"
  },
  "ngnix02" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-ngnix-02"
    vm_network_ip      = "192.168.1.102"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.1.1"
    vm_epg_name        = "web"
  },
  "ngnix03" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-ngnix-03"
    vm_network_ip      = "192.168.1.103"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.1.1"
    vm_epg_name        = "web"
  },
  "nodejs01" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-nodejs-01"
    vm_network_ip      = "192.168.2.121"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.2.1"
    vm_epg_name        = "app"
  },
  "nodejs02" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-nodejs-02"
    vm_network_ip      = "192.168.2.122"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.2.1"
    vm_epg_name        = "app"
  },
  "auth01" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-auth-01"
    vm_network_ip      = "192.168.2.201"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.2.1"
    vm_epg_name        = "auth"
  },
  "log01" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-logstash-01"
    vm_network_ip      = "192.168.2.202"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.2.1"
    vm_epg_name        = "log"
  },
  "mariadb01" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-mariadb-01"
    vm_network_ip      = "192.168.3.131"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.3.1"
    vm_epg_name        = "db"
  },
  "mariadb02" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-mariadb-02"
    vm_network_ip      = "192.168.3.132"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.3.1"
    vm_epg_name        = "db"
  },
  "dbcache01" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-dbcache-01"
    vm_network_ip      = "192.168.3.141"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.3.1"
    vm_epg_name        = "db_cache"
  },
  "dbcache02" = {
    vm_location_key    = "mdr1"
    vm_template        = "Centos-tmpl"
    vm_name            = "vm-dbcache-02"
    vm_network_ip      = "192.168.3.142"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.3.1"
    vm_epg_name        = "db_cache"
  }
}