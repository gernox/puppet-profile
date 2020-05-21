# @summary
#   Manages a PostgreSQL server
#
# @param version
#
# @param password
#
# @param dbs
#
class profile::postgresql (
  String $version,
  String $password,
  Hash $dbs = {},
) {
  class { 'postgresql::globals':
    encoding            => 'UTF-8',
    locale              => 'en_US.UTF-8',
    manage_package_repo => true,
    version             => $version,
  }

  class { 'postgresql::server':
    postgres_password => $password,
  }

  $dbs.each |$k, $v| {
    $params = $v + {
      password => postgresql::postgresql_password($v['user'], $v['password']),
    }

    postgresql::server::db { $k:
      * => $params,
    }
  }

  contain profile::postgresql::backup
}
