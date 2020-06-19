# @summary
#   Manages the bareos backup server
#
class profile::backup::server (
) {
  contain profile::postgresql

  $job_definitions = {
    'DefaultJob'          => {
      type                     => 'backup',
      file_set                 => 'LinuxDefault',
      storage                  => 'auth.gernox.de',
      pool                     => 'Incremental',
      messages                 => 'Standard',
      priority                 => '10',
      accurate                 => true,
      write_bootstrap          => '/var/lib/bareos/%c.bsr',
      full_backup_pool         => 'Full',
      differential_backup_pool => 'Differential',
      incremental_backup_pool  => 'Incremental',
    },
    'BackupBareosCatalog' => {
      description     => 'Backup the catalog database (after the nightly save)',
      job_defs        => 'DefaultJob',
      level           => 'Full',
      file_set        => 'BareosCatalog',
      schedule_res    => 'WeeklyCycleAfterBackup',
      run_before_job  => '/usr/lib/bareos/scripts/make_catalog_backup.pl MyCatalog',
      run_after_job   => '/usr/lib/bareos/scripts/delete_catalog_backup',
      write_bootstrap => '|/usr/bin/bsmtp -h localhost -f \"\(Bareos\) \" -s \"Bootstrap for Job %j\" root@localhost',
      priority        => 11,
    },
    'RestoreFiles'        => {
      description => 'Standard Restore template. Only one such job is needed for all standard Jobs/Clients/Storage ...',
      type        => 'restore',
      file_set    => 'LinuxAll',
      storage     => 'auth.gernox.de',
      pool        => 'Incremental',
      messages    => 'Standard',
      where       => '/tmp/bareos-restores',
    },
  }

  $storages = {
    'auth.gernox.de' => {
      address                 => '10.7.100.2',
      password                => 'pwd3',
      device                  => [
        'FileStorage-0'
      ],
      media_type              => 'File',
      tls_allowed_cn          => 'auth.gernox.de',
    }
  }

  $pools = {
    'Differential' => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => true,
      volume_retention     => '90 days',
      maximum_volume_bytes => '10G',
      maximum_volumes      => 200,
      label_format         => 'Differential-',
    },

    'Full'         => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => true,
      volume_retention     => '365 days',
      maximum_volume_bytes => '50G',
      maximum_volumes      => 200,
      label_format         => 'Full-',
    },

    'Incremental'  => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => true,
      volume_retention     => '30 days',
      maximum_volume_bytes => '5G',
      maximum_volumes      => 200,
      label_format         => 'Incremental-',
    },

    'Scratch'      => {
      pool_type => 'Scratch',
    }
  }

  class { '::gernox_bareos::director':
    jobdefs       => $job_definitions,
    pools         => $pools,
    storages      => $storages,
    manage_apache => false,
  }
}
