# @summary
#   Manages firewall rules for IPv6 after all system specific rules are applied
#
class profile::firewall::post_ipv6 (
  Boolean $enable_logging = $profile::firewall::enable_logging,
) {
  if $enable_logging {
    firewall { '999 IPv6 log all other requests':
      proto    => 'all',
      jump     => 'LOGGING',
      before   => undef,
      provider => 'ip6tables',
    }
  } else {
    firewall { '999 - IPv6: drop all other requests':
      proto    => 'all',
      action   => 'drop',
      provider => 'ip6tables',
      before   => undef,
    }
  }
}
