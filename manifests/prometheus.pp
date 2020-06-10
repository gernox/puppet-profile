# @summary
#   Manages prometheus server
#
# @param prometheus_version
#
# @param prometheus_alerts
#
# @param prometheus_scrape_configs
#
# @param prometheus_storage_path
#
# @param prometheus_storage_retention
#
# @param alertmanager_version
#
# @param alertmanager_receivers
#
# @param alertmanager_extra_options
#
class profile::prometheus (
  String $prometheus_version,
  Hash $prometheus_alerts,
  Array $prometheus_scrape_configs,
  String $prometheus_storage_path,
  String $prometheus_storage_retention,
  String $alertmanager_version,
  Hash $alertmanager_route,
  Array $alertmanager_receivers,
  String $alertmanager_extra_options,
) {
  # Ignore puppetdb during bootstrap
  $node_exporter_targets = $::settings::storeconfigs ? {
    true    => puppetdb_query(
      'resources { type = "Class" and title = "Profile::Prometheus::Node_exporter" and parameters.address is not null }'
    ),
    default => {}
  }.map |$c| {
    "${c['parameters']['address']}:9100"
  }

  $default_scrape_configs = [
    {
      job_name        => 'node_exporter',
      scrape_interval => '10s',
      scrape_timeout  => '10s',
      static_configs  => [
        {
          targets => $node_exporter_targets,
          labels  => {
            alias => 'node exporter',
          },
        },
      ],
    },
    {
      job_name        => 'prometheus',
      scrape_interval => '10s',
      scrape_timeout  => '10s',
      static_configs  => [
        {
          targets => [
            '127.0.0.1:9090',
          ],
          labels  => {
            alias => 'prometheus',
          },
        },
      ],
    }
  ]
  $_scrape_configs = $default_scrape_configs + $prometheus_scrape_configs

  class { '::prometheus::server':
    version              => $prometheus_version,
    alerts               => $prometheus_alerts,
    localstorage         => $prometheus_storage_path,
    storage_retention    => $prometheus_storage_retention,
    scrape_configs       => $_scrape_configs,
    extra_options        => '--web.enable-admin-api',
    alertmanagers_config => [
      {
        static_configs => [
          {
            targets => [
              '127.0.0.1:9093',
            ],
          },
        ],
      },
    ],
  }

  # class { 'prometheus::alertmanager':
  #   version       => $alertmanager_version,
  #   route         => $alertmanager_route,
  #   receivers     => $alertmanager_receivers,
  #   extra_options => $alertmanager_extra_options,
  # }
}
