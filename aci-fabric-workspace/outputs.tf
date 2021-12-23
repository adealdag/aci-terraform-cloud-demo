output "aci_application_epgs" {
  value = {
    web      = aci_application_epg.web.id
    app      = aci_application_epg.app.id
    db       = aci_application_epg.db.id
    db_cache = aci_application_epg.db_cache.id
    auth     = aci_application_epg.auth.id
    log      = aci_application_epg.log.id
  }
}
