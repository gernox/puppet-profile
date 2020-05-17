# @summary
#   Manages the prometheus node exporter
#
# @param node_exporter_version
#
# @param node_exporter_options
#
class profile::prometheus::node_exporter (
  String $version,
  String $options,
) {
  class { '::prometheus::node_exporter':
    version       => $version,
    extra_options => $options,
  }
}
