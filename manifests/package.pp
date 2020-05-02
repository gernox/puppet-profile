# @summary
#
# @param provider
#
# @param ensure
#
define profile::package (
  String $provider = 'apt',
  String $ensure   = 'present',
) {
  if !defined(Package[$title]) {
    package { $title:
      ensure   => $ensure,
      provider => $provider,
    }
  }
}
