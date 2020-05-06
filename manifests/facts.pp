# @summary
#   Configures external node facts
#
# @param type
#
# @param location
#
# @param ssh_port
#
# @param backup_port
#
class profile::facts (
  String $puppet_role           = lookup('role', String, 'first', 'default'),
  String $type                  = lookup('nodetype', String, 'first', 'server'),
  String $env                   = lookup('env', String, 'first', 'prd'),
  String $location              = $profile::location,

  Optional[String] $backup_port = $profile::backup_port,
) {
  $facts_dir = '/opt/puppetlabs/facter/facts.d'

  file { "${facts_dir}/role.txt":
    ensure  => present,
    content => "role=${puppet_role}",
  }

  file { "${facts_dir}/nodetype.txt":
    ensure  => present,
    content => "nodetype=${type}",
  }

  file { "${facts_dir}/location.txt":
    ensure  => present,
    content => "location=${location}",
  }

  file { "${facts_dir}/env.txt":
    ensure  => present,
    content => "env=${env}",
  }

  if $backup_port != undef {
    file { "${facts_dir}/backup_port.txt":
      ensure  => present,
      content => "backup_port=${backup_port}",
    }
  } else {
    file { "${facts_dir}/backup_port.txt":
      ensure => absent,
    }
  }
}
