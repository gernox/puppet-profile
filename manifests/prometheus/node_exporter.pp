# @summary
#   Manages the prometheus node exporter
#
# @param node_exporter_version
#
# @param node_exporter_options
#
class profile::prometheus::node_exporter (
  Stdlib::Compat::Ip_address $prometheus_ip,
  String $version,
  String $options,
) {
  class { '::prometheus::node_exporter':
    version       => $version,
    extra_options => $options,
  }

  firewall { "110 IPv4 allow Prometheus access from ${prometheus_ip}":
    source => $prometheus_ip,
    dport  => 9100,
    proto  => 'tcp',
    action => 'accept',
  }
}
