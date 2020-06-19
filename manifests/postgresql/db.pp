# @summary
#   Generates postgresql database
#
define profile::postgresql::db (
  String $user,
  String $password,
  Enum['present', 'absent'] $ensure = present,
  Optional[String] $encoding        = undef,
) {
  $_params = {
    password => postgresql::postgresql_password($user, $password),
  }

  if $ensure == present {
    postgresql::server::db { $title:
      user     => $user,
      encoding => $encoding,
      *        => $_params,
    }
  }
}
