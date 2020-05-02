# @summary
#   Manages a base system configuration
#
class profile::base {
  contain profile::apt::unattended_upgrades
  contain profile::dns::resolver
  contain profile::editors::vim
  contain profile::firewall
  contain profile::files
  contain profile::hardening
  contain profile::hosts
  contain profile::kernel_modules
  contain profile::logcheck
  contain profile::logs::rsyslog
  contain profile::mail::postfix
  contain profile::ntp
  contain profile::packages
  contain profile::profile
  contain profile::shells::zsh
  contain profile::smart
  contain profile::sudo
  contain profile::ssh
  contain profile::users
  contain profile::wireguard
}
