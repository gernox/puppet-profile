# @summary
#   Manages a base system configuration
#
class profile::base {
  contain profile::apt::unattended_upgrades
  contain profile::firewall
  contain profile::mail::postfix
}
