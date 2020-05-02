# @summary Manages SMART long tests
#
# @param interval
#
# @param command
#
# @param user
#
class profile::smart::long (
  String $interval = '42 0 1 * *',
  String $command  = '/usr/local/sbin/smart-test.sh long >>/dev/null',
  String $user     = 'root',
) {
  file { '/etc/cron.d/smart-long-test':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0751',
    content => template('profile/smart/basic-cron.erb'),
  }
}
