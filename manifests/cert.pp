# @summary
#   Manage a certificate
#
# @param ensure
#
# @param private_key
#
# @param public_key
#
define profile::cert (
  String $private_key,
  String $public_key,

  Enum['absent', 'present'] $ensure = present,
) {
  file { "/etc/ssl/certs/${title}.crt":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $public_key,
  }

  file { "/etc/ssl/private/${title}.key":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $private_key,
  }
}
