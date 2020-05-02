# @summary
#   Generates SSH keys for a user resource using ssh_keygen
#
# @example Generate ssh keys for any user using ssh_keygen. The user must exist before using the module
#    ssh_keygen { 'john': }
#
# @example Generate new host key
#    ssh_keygen { 'root':
#      filename => '/etc/ssh/ssh_host_rsa_key'
#    }
#
# @param user Username to create key for
#
# @param type Type of key to create
#
# @param bits Number of bits in key
#
# @param home Home directory of the user
#
# @param filename Key filename
#
# @param comment Key comment
#
# @param options Additional options to pass on to ssh-keygen
#
# @param create_ssh_dir Create a ssh directory for the user
#
define profile::ssh::keygen (
  Optional[String] $user                               = undef,
  Enum['rsa', 'dsa', 'ecdsa', 'ed25519', 'rsa1'] $type = 'rsa',
  Optional[Integer] $bits                              = undef,
  Optional[Stdlib::Absolutepath] $home                 = undef,
  Optional[Stdlib::Absolutepath] $filename             = undef,
  Optional[String] $comment                            = undef,
  Optional[Array[String]] $options                     = undef,
  Boolean $create_ssh_dir                              = false,
) {
  $_user = $user ? {
    undef   => $name,
    default => $user,
  }

  $_home = $home ? {
    undef   => $_user ? {
      'root'  => "/${_user}",
      default => "/home/${_user}",
    },
    default => $home,
  }

  $_filename = $filename ? {
    undef   => "${_home}/.ssh/id_${type}",
    default => $filename,
  }

  $type_opt = shell_join(['-t', $type])

  $bits_opt = $bits ? {
    undef   => undef,
    default => shell_join(['-b', $bits]),
  }

  $filename_opt = shell_join(['-f', $_filename])
  $passphrase_opt = shell_join(['-N', ''])

  $comment_opt = $comment ? {
    undef   => undef,
    default => shell_join(['-C', $comment]),
  }

  $options_opt = $options ? {
    undef   => undef,
    default => shell_join($options),
  }

  $command = delete_undef_values([
    'ssh-keygen',
    $type_opt,
    $bits_opt,
    $filename_opt,
    $passphrase_opt,
    $comment_opt,
    $options_opt,
  ])

  exec { "ssh_keygen-${name}":
    command => join($command, ' '),
    user    => $_user,
    creates => $_filename,
  }

  if $create_ssh_dir {
    $base_dir = dirname($_filename)

    profile::tools::create_dir { "openssh_keygen_${base_dir}":
      path   => $base_dir,
      owner  => $_user,
      before => Exec["ssh_keygen-${name}"],
    }
  }
}
