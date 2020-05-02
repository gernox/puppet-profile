# @summary
#   Generic class to manage network hardening
#
# @param modprobe_template
#   Path of the template to manage /etc/modprobe.d/hardening.conf
#
# @param netconfig_template
#   Path of the template to manage /etc/netconfig
#
# @param blacklist_template
#   Path of the template to manage /etc/modprobe.d/blacklist-nouveau.conf
#
# @param services_template
#   Path of the template to manage /etc/services
#
class profile::hardening::network (
  Optional[String] $modprobe_template  = undef,
  Optional[String] $netconfig_template = undef,
  Optional[String] $blacklist_template = undef,
  Optional[String] $services_template  = undef,
) {
  if $modprobe_template {
    file { '/etc/modprobe.d/hardening.conf':
      ensure  => file,
      content => template($modprobe_template),
    }
  }

  if $netconfig_template {
    file { '/etc/netconfig':
      ensure  => file,
      content => template($netconfig_template),
    }
  }

  if $blacklist_template {
    file { '/etc/modprobe.d/blacklist-nouveau.conf':
      ensure  => file,
      content => template($blacklist_template),
    }
  }

  if $services_template {
    file { '/etc/services':
      ensure  => file,
      content => template($services_template),
    }
  }

}
