# @summary
#   Manages the OpenSSH server
#
# @param authorized_keys
#   Hash of public SSH keys to be stored in root's authorized_keys file
#
# @param server_description
#   Specific server description for MOTD
#
# @param motd_template
#   Path to template used for MOTD
#
class profile::ssh::server (
  Hash $authorized_keys,
  String $server_name,
  String $description,
  String $motd_template,
) {
  file { '/etc/motd':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => template($motd_template),
  }

  # Default configuration for the ssh_authorized_key type
  $default = {
    ensure => absent,
    user   => 'root',
  }

  create_resources('ssh_authorized_key', $authorized_keys, $default)

  # Enforce strict sshd options
  class { '::ssh::server':
    storeconfigs_enabled => false,
    options              => {
      'X11Forwarding'          => 'no',
      'PrintMotd'              => 'yes',
      'Banner'                 => 'no',
      'IgnoreRhosts'           => 'yes',
      'PrintLastLog'           => 'yes',
      'PermitRootLogin'        => 'yes',
      'Port'                   => '22',
      'PasswordAuthentication' => 'no',
      'PubkeyAuthentication'   => 'yes',
      'Protocol'               => '2',
      'StrictModes'            => 'yes',
      'UsePAM'                 => 'no',
      'SyslogFacility'         => 'AUTH',
      'LogLevel'               => 'INFO',
    },
  }
}
