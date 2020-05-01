# @summary
#   Manages the basic firewall configuration for IPv4, before system specific rules are applied
#
# @param forward_policy
#   Policy for forwarding table
#
# @param ignore_rules
#   List of rules to ignore when purging
#
class profile::firewall::post {
  contain profile::firewall::post_ipv4
  contain profile::firewall::post_ipv6
}
