# @summary
#
# @param provider
#
# @param ensure
#
class profile::packages (
  Hash $packages = {},
) {
  $package_default = {
    ensure   => present,
    provider => 'apt',
  }

  create_resources('profile::package', $packages, $package_default)
}
