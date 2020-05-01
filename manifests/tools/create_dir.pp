# @summary
#   Create a directry and its eventual parents
#
# @example
#   Create the directory /gernox/utils/bin
#     profile::tools::create_dir { '/gernox/utils/bin': }
#
# @param path
#   The directory path
#
# @param owner
#   The owner of the created directory
#
# @param group
#   The group of the created directory
#
# @param mode
#   The mode of the created directory
#
define profile::tools::create_dir (
  Optional[String] $path  = undef,
  Optional[String] $owner = undef,
  Optional[String] $group = undef,
  Optional[String] $mode  = undef,
) {

  $_path = $path ? {
    undef   => $title,
    default => $path,
  }

  exec { "mkdir -p ${_path}":
    path    => '/bin:/sbin:/usr/sbin:/usr/bin',
    creates => $_path,
  }

  if $owner {
    exec { "chown ${owner} ${_path}":
      path   => '/bin:/sbin:/usr/sbin:/usr/bin',
      onlyif => "[ $(ls -ld ${_path} | awk '{ print \$3 }') != ${owner} ]",
    }
  }

  if $group {
    exec { "chgrp ${group} ${_path}":
      path   => '/bin:/sbin:/usr/sbin:/usr/bin',
      onlyif => "[ $(ls -ld ${_path} | awk '{ print \$4 }') != ${group} ]",
    }
  }

  if $mode {
    exec { "chmod ${mode} ${_path}":
      path        => '/bin:/sbin:/usr/sbin:/usr/bin',
      subscribe   => Exec["mkdir -p ${_path}"],
      refreshonly => true,
    }
  }

}
