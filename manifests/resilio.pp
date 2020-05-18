# @summary
#   Manages the Resilio client
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
class profile::resilio (
  String $device_name,
  Integer $listening_port,
  String $storage_path,
  Integer $download_limit,
  Integer $upload_limit,
  String $directory_root,
  String $webui_listen_host,
  Integer $webui_listen_port,
  String $webui_user,
  String $webui_password,
) {
  contain ::profile::resilio::repo
  contain ::profile::resilio::install

  # Order of execution
  Class['::profile::resilio::repo']
  -> Class['::profile::resilio::install']
}
