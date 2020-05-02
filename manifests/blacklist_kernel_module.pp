# @summary
#   Blacklist a kernel module
#
# @param blacklist
#
define profile::blacklist_kernel_module (
  $ensure = present,
) {
  file { "/etc/modprobe.d/blacklist-${title}.conf":
    ensure  => $ensure,
    content => "blacklist ${title}",
  }
}
