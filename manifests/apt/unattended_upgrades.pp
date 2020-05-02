# @summary
#   Manages unattended upgrades for apt
#
# @param manage_package
#
# @param package_name
#
# @param email
#
# @param autofix
#
# @param minimal_steps
#
# @param on_shutdown
#
# @param on_error
#
# @param auto_remove
#
# @param auto_reboot
#
# @param reboot_time
#
# @param automation_file
#
# @param configuration_file
#
# @param repositories
#
class profile::apt::unattended_upgrades (
  Boolean $manage_package,
  String $package_name,
  String $email,
  Boolean $autofix,
  Boolean $minimal_steps,
  Boolean $on_shutdown,
  Boolean $on_error,
  Boolean $auto_remove,
  Boolean $auto_reboot,
  String $reboot_time,
  String $automation_file,
  String $configuration_file,
  Array[String] $repositories,
) {
  if $manage_package {
    package { $package_name:
      ensure => present,
    }
  }

  service { 'unattended-upgrades':
    ensure => running,
    enable => true,
  }

  file { $automation_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profile/apt/unattended_upgrades/automation.erb'),
  }

  file { $configuration_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profile/apt/unattended_upgrades/configuration.erb'),
  }
}
