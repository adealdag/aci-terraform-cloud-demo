# Configure provider with your Cisco ACI credentials
provider "aci" {
  url      = var.aci_url
  username = var.aci_username
  password = var.aci_password
  # private_key = "file(/Users/adealdag/.ssh/labadmin.key)"
  # cert_name = "labadmin.crt"
  insecure = true
}
