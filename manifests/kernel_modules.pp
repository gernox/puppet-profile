# @summary
#   Manages kernel module configurations
#
# @param blacklist
#
class profile::kernel_modules (
  Hash $blacklist = $::profile::blacklist_kernel_modules,
) {
  file { '/etc/modprobe.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  $blacklist_default = {
    ensure  => present,
    require => File['/etc/modprobe.d'],
  }

  create_resources('profile::blacklist_kernel_module', $blacklist, $blacklist_default)
}
