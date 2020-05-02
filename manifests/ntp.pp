# @summary
#   Manages NTP
#
# @param servers
#   List of NTP servers
#
# @param restrictions
#   NTP restriction
#
# @param driftfile
#
class profile::ntp (
  Array[String] $servers,
  Array[String] $restrictions,
  String $driftfile = '/var/lib/ntp/ntp.drift',
) {
  class { '::ntp':
    driftfile     => $driftfile,
    iburst_enable => true,
    restrict      => $restrictions,
    servers       => $servers,
  }
}
