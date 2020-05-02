# @summary
#   Handles default files and directories
#
# @param base_dir
#
# @param backup_paths
#
class profile::files (
  String $base_dir    = '/gernox',
  Array $backup_paths = [],
) {

  profile::tools::create_dir { '/root/.ssh':
    owner => 'root',
    group => 'root',
    mode  => '0700',
  }

  profile::tools::create_dir { '/opt': }

  profile::tools::create_dir { $base_dir: }
  profile::tools::create_dir { "${base_dir}/etc": }
  profile::tools::create_dir { "${base_dir}/data": }
  profile::tools::create_dir { "${base_dir}/backups": }

  file { "${base_dir}/backup-fileset":
    ensure  => present,
    content => template('profile/backup-fileset.erb'),
    require => Profile::Tools::Create_dir[$base_dir],
  }
}
