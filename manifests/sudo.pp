# @summary
#   Manages sudo
#
# @param sudoers_template
#   The template to use for /etc/sudoers. If empty the file is not managed
#
# @param admins
#   The array of users to add to the admin group
#
# @param sudoers_d_source
#   The source to use to populate the /etc/sudoers.d directory
#
# @param purge_sudoers_dir
#   If to purge all the files existing on the local node and not present in sudoers_d_source
#
# @param directives
#   A hash of sudo directives to pass to profile::sudo::directive
#
class profile::sudo (
  String $sudoers_template                    = '',
  Array $admins                               = [],
  Variant[String[1], Undef] $sudoers_d_source = undef,
  Boolean $purge_sudoers_dir                  = false,
  Hash $directives                            = {},
) {
  if $sudoers_template != '' {
    file { '/etc/sudoers':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content => template($sudoers_template),
      notify  => Exec['sudo_syntax_check'],
    }

    file { '/etc/sudoers.broken':
      ensure => absent,
      before => Exec['sudo_syntax_check'],
    }

    exec { 'sudo_syntax_check':
      command     => @(EOT)
        /usr/sbin/visudo -c -f /etc/sudoers && ( cp -f /etc/sudoers /etc/sudoers.lastgood ) || \
        ( /bin/mv -f /etc/sudoers /etc/sudoers.broken ; /bin/cp /etc/sudoers.lastgood /etc/sudoers ; exit 1)
        |EOT
      ,
      refreshonly => true,
    }
  }

  file { '/etc/sudoers.d':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    source  => $sudoers_d_source,
    recurse => true,
    purge   => $purge_sudoers_dir,
  }

  $directives.each |$name, $opts| {
    ::profile::sudo::directive { $name:
      * => $opts,
    }
  }
}
