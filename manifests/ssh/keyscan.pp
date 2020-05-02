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
    command => "ssh-keyscan ${host} >> ${_known_hosts_path}",
    user    => $user,
    unless  => "/bin/grep ${host} ${_known_hosts_path}",
    require => Profile::Tools::Create_dir[$_known_hosts_path],
  }

  if !defined(Profile::Tools::Create_dir[$_known_hosts_path]) {
    profile::tools::create_dir { $_known_hosts_path:
      owner => $user,
    }
  }
}
