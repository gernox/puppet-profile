# @summary
#   Manages a base system configuration
#
class profile::base {
  contain profile::firewall
  contain profile::mail::postfix
}
