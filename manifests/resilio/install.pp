# @summary
#   Manages the Resilio repository
#
# @param device_name
#
# @param listening_port
#
# @param storage_path
#
# @param download_limit
#
# @param upload_limit
#
# @param directory_root
#
# @param webui_listen_host
#
# @param webui_listen_port
#
# @param webui_user
#
# @param webui_password
#
class profile::resilio::install (
  String $device_name        = $profile::resilio::device_name,
  Integer $listening_port    = $profile::resilio::listening_port,
  String $storage_path       = $profile::resilio::storage_path,
  Integer $download_limit    = $profile::resilio::download_limit,
  Integer $upload_limit      = $profile::resilio::upload_limit,
  String $directory_root     = $profile::resilio::directory_root,
  String $webui_listen_host  = $profile::resilio::webui_listen_host,
  Integer $webui_listen_port = $profile::resilio::webui_listen_port,
  String $webui_user         = $profile::resilio::webui_user,
  String $webui_password     = $profile::resilio::webui_password,
) {
  $conf_path = '/etc/resilio-sync/config.json'

  package { 'resilio-sync':
    ensure => present,
  }

  file { $conf_path:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profile/resilio/config.json.erb'),
    require => Package['resilio-sync'],
    notify  => Service['resilio-sync'],
  }

  service { 'resilio-sync':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['resilio-sync'],
  }
}
