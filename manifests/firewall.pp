# @summary
#   Manages the iptables configuration
#
# @param forward_policy
#   Policy for forwarding table
#
# @param ignore_rules
#   List of rules to ignore when purging
#
# @param enable_logging
#   Should dropped packets be logged?
#   Default: false
#
# @param system_rules
#   List of rules to apply
#
class profile::firewall (
  Enum['accept', 'drop'] $forward_policy,
  Array $ignore_rules,

  Boolean $enable_logging      = false,
  Optional[Hash] $system_rules = undef,
) {
  Firewall {
    before  => Class['profile::firewall::post'],
    require => Class['profile::firewall::pre'],
  }

  # Default Rules that are always applied
  contain profile::firewall::pre
  contain profile::firewall::post

  # Include firewall module
  contain ::firewall

  if ($system_rules) {
    create_resources('firewall', $system_rules)
  }
}
