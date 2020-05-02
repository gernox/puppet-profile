# @summary
#   Manages a base system configuration
#
class profile::base {
  contain profile::apt::unattended_upgrades
  contain profile::dns::resolver
  contain profile::editors::vim
  contain profile::firewall
  contain profile::hardening
  contain profile::mail::postfix
}
