# @summary
#   Manages the Resilio repository
#
# @param repo_url
#
# @param key_id
#
# @param key_url
#
class profile::resilio::repo (
  String $repo_url,
  String $key_id,
  String $key_url,
) {
  apt::source { 'resilio':
    location => $repo_url,
    release  => 'resilio-sync',
    repos    => 'non-free',

  }

  apt::key { 'resilio':
    ensure => present,
    id     => $key_id,
    source => $key_url,
  }
}
