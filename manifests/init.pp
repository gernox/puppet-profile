# @summary
#   Puppet entry point
#
# @example
#   contian profile
#
# @param manage
#
# @param auto_prereq
#
# @param enable_firstrun
#
# @param noop_mode
#
# @param fqdn
#
# @param hostname
#
# @param location
#
# @param node_type
#
# @param role
#
# @param primary_ip
#
# @param primary_interface
#
# @param timezone
#
# @param hosts
#
# @param backup_port
#
# @param backup_paths
#
# @param base_dir
#
# @param sysctl_entries
#
# @param blacklist_kernel_modules
#
# @param packages
#
# @param settings
#
# @param force_ordering
#
class profile (
  # global vars
  Boolean $manage                                  = true,
  Boolean $enable_firstrun                         = false,
  Boolean $noop_mode                               = lookup('noop_mode', Boolean, 'first', true),

  String $fqdn                                     = $::fqdn,
  String $hostname                                 = $::hostname,
  String $domain                                   = $::domain,
  Optional[String] $role                           = $::role,

  # General network settings
  Optional[Stdlib::Compat::Ip_address] $primary_ip = fact('networking.ip'),
  Optional[String] $primary_interface              = fact('networking.primary'),
  Optional[String] $timezone                       = undef,
  Hash $hosts                                      = {},

  # Backup settings
  Optional[String] $backup_port                    = undef,
  Optional[Array[String]] $backup_paths            = [],

  # System settings
  String $base_dir                                 = '/gernox',
  Hash $sysctl_entries                             = {},
  Hash $blacklist_kernel_modules                   = {},
  Hash $packages                                   = {},

  # General endpoints and variables
  Hash $settings                                   = {},
  Boolean $force_ordering                          = true,

) {
  if $facts['firstrun'] == 'done' or $enable_firstrun == false {
    contain ::profile::pre
    contain ::profile::base
    contain ::profile::profiles

    if $force_ordering {
      Class['profile::pre']
      -> Class['profile::base']
      -> Class['profile::profiles']
    }
  } else {
    contain ::profile::firstrun
    notify { "This catalog should be applied only at the first Puppet run\n": }
  }
}
