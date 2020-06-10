# @summary
#   Manages Nextcloud
#
class profile::nextcloud (
  String $version,
  Stdlib::HTTPUrl $archive_url,
  String $app_dir,
  String $data_dir,
  String $system_user,
  String $system_group,
  String[1] $db_password,
  String $db_name,
  String $db_user,
  Stdlib::Host $db_host,
  Integer $db_port,
  String $fqdn,
) {

  $_default_config = {
    'dbhost'              => $db_host,
    'dbname'              => $db_name,
    'dbuser'              => $db_user,
    'dbpassword'          => $db_password,
    'datadirectory'       => $data_dir,
    'trusted_domains'     => ['localhost', $fqdn],
  }
  $_real_config = $_default_config

  file { [ $app_dir, $_real_config['datadirectory'] ]:
    ensure => directory,
    owner  => $system_user,
    group  => $system_user,
    mode   => '0700',
  }

  archive { "nextcloud-${version}":
    path         => "/tmp/nextcloud-${version}.zip",
    source       => "${archive_url}/nextcloud-${version}.zip",
    extract      => true,
    extract_path => $app_dir,
    creates      => "${app_dir}/nextcloud/index.php",
    cleanup      => true,
    user         => $system_user,
    group        => $system_group,
    require      => [
      File[$app_dir],
      File[$data_dir],
    ],
  }

}
