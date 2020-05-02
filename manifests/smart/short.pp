# @summary
#   Manages SMART short tests
#
# @param interval
#
# @param command
#
# @param user
#
class profile::smart::short (
  String $interval = '42 22 * * *',
  String $command  = '/usr/local/sbin/smart-test.sh short >>/dev/null',
  String $user     = 'root',
) {
  file { '/etc/cron.d/smart-short-test':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0751',
    content => template('profile/smart/basic-cron.erb'),
  }
}
