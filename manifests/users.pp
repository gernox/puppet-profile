# @summary
#   Manages users of a host
#
# @param root_pw
#   The root password. If set the root user resource is managed here.
#
# @param root_params
#   A hash of valid arguments of the user type. If this or root_pw is set, the root user is managed.
#
# @param users_hash
#   A hash passed to create resources based on the selected module.
#
# @param available_users_hash
#
# @param available_users_to_add
#
# @param module
#   A string to define which module to use to manage users:
#     'user' to use Puppet native type
#     'accounts' to use accounts::user from puppetlabs-accounts module
#
# @param delete_unmanaged
#   If true all non system users not managed by Puppet are automatically deleted.
#
# @param skel_dir_source
#   The source from where to sync files to place on /etc/skel
#
class profile::users (
  Optional[String[1]] $root_pw      = undef,
  Hash $root_params                 = {},
  Hash $users_hash                  = {},
  Hash $available_users_hash        = {},
  Array $available_users_to_add     = [],
  Enum['accounts', 'user'] $module  = 'user',
  Boolean $delete_unmanaged         = false,
  Optional[String] $skel_dir_source = undef,
) {
  if $skel_dir_source {
    file { '/etc/skel':
      ensure  => directory,
      source  => $skel_dir_source,
      recurse => true,
    }
    File['/etc/skel'] -> User<||>
  }

  if $root_pw or $root_params != {} {
    @user { 'root':
      ensure         => present,
      home           => '/root',
      purge_ssh_keys => true,
      password       => $root_pw,
      *              => $root_params,
    }
  }

  $added_users = $available_users_hash.filter | $username, $key | {
    $username in $available_users_to_add
  }
  $all_users = $added_users + $users_hash

  if $all_users != {} {
    $all_users.each |$u, $rv| {
      $v = delete($rv, [
        'ssh_authorized_keys',
        'openssh_keygen',
        'sudo_template',
      ])

      # Find home
      if $v['home'] {
        $home_real = $v['home']
      } elsif $u == 'root' {
        $home_real = $::osfamily ? {
          default => '/root',
        }
      } else {
        $home_real = $::osfamily ? {
          default => "/home/${u}",
        }
      }

      case $module {
        'accounts': {
          accounts::user { $u:
            ensure   => $v['ensure'],
            comment  => $v['comment'],
            gid      => $v['gid'],
            groups   => $v['groups'],
            home     => $v['home'],
            password => $v['password'],
            shell    => $v['shell'],
            uid      => $v['uid'],
            sshkeys  => $v['sshkeys'],
            *        => pick_default($v['extra_params'], {}),
          }
        }
        default: {
          user { $u:
            ensure           => $v['ensure'],
            comment          => $v['comment'],
            gid              => $v['gid'],
            groups           => $v['groups'],
            home             => $home_real,
            password         => $v['password'],
            password_max_age => $v['password_max_age'],
            password_min_age => $v['password_min_age'],
            shell            => $v['shell'],
            uid              => $v['uid'],
            managehome       => $v['managehome'],
            *                => pick_default($v['extra_params'], {}),
          }
        }
      }

      if has_key($rv, 'ssh_authorized_keys') and $module != 'accounts' {
        $rv['ssh_authorized_keys'].each |$key| {
          $key_array = split($key, ' ')

          ssh_authorized_key { "${u}_${key}":
            ensure => present,
            user   => $u,
            name   => $key_array[2],
            key    => $key_array[1],
            type   => $key_array[0],
            target => "${home_real}/.ssh/authorized_keys",
          }
        }
      }

      if has_key($rv, 'openssh_keygen') {
        $rv['openssh_keygen'].each |$u, $vv| {
          profile::openssh::keygen { $u:
            * => $vv,
          }
        }
      }

      if has_key($rv, 'sudo_template') {
        profile::sudo::directive { $u:
          template => $rv['sudo_template'],
        }
      }
    }
  }

  if $delete_unmanaged {
    resources { 'user':
      purge              => true,
      unless_system_user => true,
    }
  }
}
