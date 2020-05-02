# @summary
#   Manges tcpwrappers
#
# @param hosts_allow_template
#   The template to use to manage the content of /etc/hosts.allow
#
# @param hosts_deny_template
#   The template to use to manage the content of /etc/hosts.deny
#
class profile::hardening::tcpwrappers (
  String $hosts_allow_template = 'profile/hardening/tcpwrappers/hosts.allow.erb',
  String $hosts_deny_template  = 'profile/hardening/tcpwrappers/hosts.deny.erb',
) {
  if $hosts_allow_template != '' {
    file { '/etc/hosts.allow':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($hosts_allow_template),
    }
  }

  if $hosts_deny_template != '' {
    file { '/etc/hosts.deny':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($hosts_deny_template),
    }
  }
}
