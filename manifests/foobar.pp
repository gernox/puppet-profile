class profile::foobar () {
  file { '/etc/foobar':
    ensure  => file,
    backup  => false,
    content => 'foobar??',
  }
}
