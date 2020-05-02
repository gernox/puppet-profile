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
  String $host                   = $::hostname,
  Variant[Undef, String] $fqdn   = $::fqdn,
  Variant[Undef, String] $domain = $::domain,
  String $ip                     = $::ipaddress,

  Boolean $update_hostname       = true,
  Boolean $update_host_entry     = true,
) {

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
