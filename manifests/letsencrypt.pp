# @summary
#   Manages LetsEncrypt configuration
#
# @param email
#
class profile::letsencrypt (
  String $email,
  String $server,
) {
  class { '::letsencrypt':
    email  => 'foo@example.com',
    config => {
      'server' => $server,
    },
  }
}
