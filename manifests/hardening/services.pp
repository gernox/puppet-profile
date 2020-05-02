# @summary
#   Generic class to remove unncessary services
#
# @param services_to_remove
#   List of services to disable
#
# @param services_default
#   Default list, OS dependent, of services to disable
#
# @param remove_default_services
#   If to remove the services listed in services_default
#
class profile::hardening::services (
  Array $services_to_remove        = [],
  Array $services_default          = [],
  Boolean $remove_default_services = true,
) {
  $services = $remove_default_services ? {
    true  => $services_to_remove + $services_default,
    false => $services_to_remove,
  }

  $services.each |$svc| {
    service { $svc:
      ensure => stopped,
      enable => false,
    }
  }
}
