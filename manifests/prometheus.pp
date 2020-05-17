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
  class { '::prometheus::server':
    version              => $prometheus_version,
    alerts               => $prometheus_alerts,
    localstorage         => $prometheus_storage_path,
    storage_retention    => $prometheus_storage_retention,
    scrape_configs       => $prometheus_scrape_configs,
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

  class { 'prometheus::alertmanager':
    version       => $alertmanager_version,
    route         => $alertmanager_route,
    receivers     => $alertmanager_receivers,
    extra_options => $alertmanager_extra_options,
  }
}
