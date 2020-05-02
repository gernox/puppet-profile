# @summary
#   Manages the general hardening of a system
#
# @example
#   Define the hardening classes to include. Set a class name to an empty string to avoid to include it
#    onsuma::hardening::pam_class: ''
#    onsuma::hardening::packages_class: ''
#
# @param manage
#   If to actually manage any resource
#
# @param fail2ban_class
#   Name of the class to include to manage fail2ban
#
# @param pam_class
#   Name of the class to include to manage PAM
#
# @param packages_class
#   Name of the class where packages to remove are defined
#
# @param services_class
#   Name of the class where services to remove are defined
#
# @param securetty_class
#   Name of the class where /etc/securetty is managed
#
# @param tcpwrappers_class
#   Name of the class to manage TCP wrappers
#
# @param network_class
#   Name of the class to manage network hardening
#
class profile::hardening (
  Boolean $manage           = true,

  String $fail2ban_class    = 'profile::hardening::fail2ban',
  String $network_class     = 'profile::hardening::network',
  String $packages_class    = 'profile::hardening::packages',
  String $pam_class         = 'profile::hardening::pam',
  String $securetty_class   = 'profile::hardening::securetty',
  String $services_class    = 'profile::hardening::services',
  String $sysctl_class      = 'profile::hardening::sysctl',
  String $tcpwrappers_class = 'profile::hardening::tcpwrappers',
) {
  if $fail2ban_class != '' and $manage {
    contain $fail2ban_class
  }

  if $network_class != '' and $manage {
    contain $network_class
  }

  if $packages_class != '' and $manage {
    contain $packages_class
  }

  if $pam_class != '' and $manage {
    contain $pam_class
  }

  if $securetty_class != '' and $manage {
    contain $securetty_class
  }

  if $services_class != '' and $manage {
    contain $services_class
  }

  if $sysctl_class != '' and $manage {
    contain $sysctl_class
  }

  if $tcpwrappers_class != '' and $manage {
    contain $tcpwrappers_class
  }
}
