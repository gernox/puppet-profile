# @summary
#   Manages DNS resolver configuration in /etc/resolv.conf
#
# @param nameservers
#
# @param options
#
# @param resolver_config_file
#
# @param resolver_config_file_ensure
#
# @param resolver_config_file_owner
#
# @param resolver_config_file_group
#
# @param resolver_config_file_mode
#
# @param search
#
# @param domain
#
# @param sortlist
#
class profile::dns::resolver (
  Array[String] $nameservers,
  Array[String] $options,
  String $resolver_config_file,
  Enum['absent', 'file', 'present'] $resolver_config_file_ensure,
  String $resolver_config_file_owner,
  String $resolver_config_file_group,
  String $resolver_config_file_mode,

  Optional[Array[String]] $search   = undef,
  Optional[String] $domain          = undef,
  Optional[Array[String]] $sortlist = undef,
) {
  if $domain != undef and is_domain_name($domain) != true {
    fail("Invalid domain name: ${domain}")
  }

  if $::virtual != 'docker' {
    file { 'dns_resolver_config_file':
      ensure  => $resolver_config_file_ensure,
      content => template('profile/dns/resolver/resolv.conf.erb'),
      path    => $resolver_config_file,
      owner   => $resolver_config_file_owner,
      group   => $resolver_config_file_group,
      mode    => $resolver_config_file_mode,
    }
  }
}
