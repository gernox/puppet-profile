# @summary
#   Scans a host key and add it to the known_hosts file of the defined user
#
# @param user
#
# @param host
#
# @param known_hosts_path
#
define profile::ssh::keyscan (
  String $user                                     = 'root',
  String $host                                     = $title,
  Integer $port                                    = 22,

  Optional[Stdlib::AbsolutePath] $known_hosts_path = undef,
) {
  $_known_hosts_path = $known_hosts_path ? {
    undef   => $user ? {
      'root'  => '/root/.ssh/known_hosts',
      default => "/home/${user}/.ssh/known_hosts",
    },
    default => $known_hosts_path,
  }

  $known_hosts_dir = dirname($_known_hosts_path)

  exec { "ssh-keyscan-${title}":
    command => "/usr/bin/ssh-keyscan -p ${port} ${host} >> ${_known_hosts_path}",
    user    => $user,
    unless  => "/bin/grep '\[${host}\]:${port}' ${_known_hosts_path}",
    require => Profile::Tools::Create_dir[$known_hosts_dir],
  }

  if !defined(Profile::Tools::Create_dir[$known_hosts_dir]) {
    profile::tools::create_dir { $known_hosts_dir:
      owner => $user,
    }
  }
}
