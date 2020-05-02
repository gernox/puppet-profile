# @summary
#   Generic class to remove unnecessary packages
#
# @param packages_to_remove
#   List of packages to remove
#
# @param packages_default
#   Default list, OS dependent, of packages to remove
#
# @param remove_default_packages
#   If to remove the packages listed in packages_default
#
class profile::hardening::packages (
  Array $packages_to_remove        = [],
  Array $packages_default          = [],
  Boolean $remove_default_packages = true,
) {
  $packages = $remove_default_packages ? {
    true  => $packages_to_remove + $packages_default,
    false => $packages_to_remove,
  }

  $packages.each |$pkg| {
    package { $pkg:
      ensure => absent,
    }
  }
}
