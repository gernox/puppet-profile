# @summary
#   Manages the nginx configuration for a docker registry
#
# @param http_domain
#
# @param port
#
class profile::docker::registry::nginx (
  String $http_domain,

  Integer $port = $profile::docker::registry::port,
) {
  contain profile::nginx

  nginx::resource::map { 'docker_distribution_api_version':
    string   => '$upstream_http_docker_distribution_api_version',
    mappings => [
      { 'key' => "''", 'value' => "'registry/2.0'" },
    ]
  }

  nginx::resource::server { 'docker-registry':
    server_name          => [
      $http_domain,
    ],
    listen_port          => 443,
    format_log           => 'anonymized',
    ssl                  => true,
    ssl_cert             => '/etc/ssl/certs/gernox_it.crt',
    ssl_key              => '/etc/ssl/private/gernox_it.key',
    client_max_body_size => 0,
    location_cfg_append  => {
      chunked_transfer_encoding => true,
    },
    add_header           => {
      'Docker-Distribution-Api-Version' => '$docker_distribution_api_version always'
    },
    locations            => {
      docker_registry_v2 => {
        location           => '/v2/',
        proxy              => "http://localhost:${port}/",
        proxy_set_header   => [
          'Host $http_host',
          'X-Real-IP $remote_addr',
          'X-Forwarded-For $proxy_add_x_forwarded_for',
          'X-Forwarded-Proto $scheme',
        ],
        proxy_read_timeout => '900s',
        raw_append         => [
          'if ($http_user_agent ~ "^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*$" ) {',
          '  return 404;',
          '}',
        ],
      }
    },
  }
}
