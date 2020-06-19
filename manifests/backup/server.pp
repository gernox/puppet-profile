# @summary
#   Manages the bareos backup server
#
class profile::backup::server (
  Hash $storages,
) {
  contain profile::postgresql

  $job_definitions = {
    'AlwaysIncremental'            => {
      file_set                         => 'LinuxDefault',
      type                             => 'Backup',
      level                            => 'Incremental',
      schedule_res                     => 'AlwaysIncrementalSched',
      storage                          => 'File',
      messages                         => 'Standard',
      pool                             => 'AI-Incremental',
      priority                         => '15',
      write_bootstrap                  => '/var/lib/bareos/%c.bsr',
      full_backup_pool                 => 'AI-Consolidated',
      incremental_backup_pool          => 'AI-Incremental',
      accurate                         => true,
      allow_mixed_priority             => true,
      always_incremental               => true,
      always_incremental_job_retention => '7 days',
      always_incremental_keep_number   => 7,
      always_incremental_max_full_age  => '21 days',
    },
    'AlwaysIncrementalConsolidate' => {
      file_set                => 'LinuxDefault',
      type                    => 'Consolidate',
      schedule_res            => 'ConsolidateSched',
      storage                 => 'File',
      messages                => 'Standard',
      pool                    => 'AI-Consolidated',
      priority                => '25',
      write_bootstrap         => '/var/lib/bareos/%c.bsr',
      full_backup_pool        => 'AI-Consolidated',
      incremental_backup_pool => 'AI-Incremental',
      accurate                => true,
      max_full_consolidations => 1,
      prune_volumes           => true,
    },
    'AlwaysIncrementalLongTerm'    => {
      file_set     => 'LinuxDefault',
      type         => 'Backup',
      level        => 'VirtualFull',
      schedule_res => 'LongTermSched',
      storage      => 'File',
      messages     => 'Standard',
      pool         => 'AI-Consolidated',
      priority     => '30',
      accurate     => true,
      run_script   => {
        'console'         => '"update jobid=%i jobtype=A"',
        'Runs When'       => 'After',
        'Runs On Client'  => 'No',
        'Runs on Failure' => 'No',
      }
    },
    'DefaultJob'                   => {
      type                     => 'Backup',
      file_set                 => 'LinuxDefault',
      pool                     => 'Incremental',
      messages                 => 'Standard',
      priority                 => '10',
      accurate                 => true,
      write_bootstrap          => '/var/lib/bareos/%c.bsr',
      full_backup_pool         => 'Full',
      differential_backup_pool => 'Differential',
      incremental_backup_pool  => 'Incremental',
    },
    'BackupBareosCatalog'          => {
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
    'RestoreFiles'                 => {
      description => 'Standard Restore template. Only one such job is needed for all standard Jobs/Clients/Storage ...',
      type        => 'restore',
      file_set    => 'LinuxAll',
      storage     => 'File',
      pool        => 'Incremental',
      messages    => 'Standard',
      where       => '/tmp/bareos-restores',
    },
  }

  $pools = {
    'AI-Incremental'  => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => false,
      maximum_volume_bytes => '5G',
      label_format         => 'AI-Incremental-',
      volume_use_duration  => '7 days',
      storage              => 'File',
      next_pool            => 'AI-Consolidated',
      volume_retention     => '1 years',
      maximum_volumes      => 15,
    },
    'AI-Consolidated' => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => false,
      maximum_volume_bytes => '5G',
      label_format         => 'AI-Consolidated-',
      volume_use_duration  => '18 hours',
      storage              => 'FileConsolidated',
      next_pool            => 'AI-LongTerm',
      volume_retention     => '1 years',
      maximum_volumes      => 75,
    },
    'AI-LongTerm'     => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => true,
      maximum_volume_bytes => '10G',
      label_format         => 'AI-LongTerm-',
      volume_use_duration  => '2 days',
      storage              => 'FileVirtualLongTerm',
      volume_retention     => '180 days',
      maximum_volumes      => 100,
    },
    'Differential'   => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => true,
      volume_retention     => '90 days',
      maximum_volume_bytes => '10G',
      maximum_volumes      => 200,
      label_format         => 'Differential-',
    },

    'Full'           => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => true,
      volume_retention     => '365 days',
      maximum_volume_bytes => '50G',
      maximum_volumes      => 200,
      label_format         => 'Full-',
    },

    'Incremental'    => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => true,
      volume_retention     => '30 days',
      maximum_volume_bytes => '5G',
      maximum_volumes      => 200,
      label_format         => 'Incremental-',
    },
    'Scratch'         => {
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
