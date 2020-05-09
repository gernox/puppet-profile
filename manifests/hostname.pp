# @summary
#   Manages the hostname of a host
#
# @param host
#
# @param fqdn
#
# @param domain
#
# @param ip
#
# @param update_hostname
#
# @param update_host_entry
#
class profile::hostname (
  String $host                   = $profile::hostname,
  Variant[Undef, String] $fqdn   = $profile::fqdn,
  Variant[Undef, String] $domain = $profile::domain,
  String $ip                     = $profile::primary_ip,

  Boolean $update_hostname       = true,
  Boolean $update_host_entry     = true,

  Boolean $no_noop               = false,
) {

  if !$::profile::noop_mode and $no_noop {
    info('Forces no-noop mode.')
    noop(false)
  }

  case $::kernel {
    'Linux': {
      if $::is_virtual != 'docker' {
        if $update_hostname {
          $hostname_content = $fqdn ? {
            true    => "${fqdn}\n",
            default => "${host}.${domain}\n"
          }

          file { '/etc/hostname':
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => $hostname_content,
            notify  => Exec['apply_hostname'],
          }

          exec { 'apply_hostname':
            command => '/bin/hostname -F /etc/hostname',
            unless  => '/usr/bin/test `hostname` = `/bin/cat /etc/hostname`',
          }
        }

        if $update_host_entry {
          host { $host:
            ensure       => present,
            host_aliases => $fqdn,
            ip           => $ip,
          }
        }
      }
    }

    default: {
      notice("profile::hostname does not support ${::kernel}")
    }
  }
}
