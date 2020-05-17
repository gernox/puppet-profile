# @summary
#   Manages nginx configuration
#
# @param servers
#
class profile::nginx (
  Hash $servers = {},
) {
  class { '::nginx':
    confd_purge     => true,
    server_purge    => true,
    http_access_log => 'off',
  }

  create_resources('nginx::resource::server', $servers)
}
