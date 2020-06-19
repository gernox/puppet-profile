# @summary
#   Manages the bareos backup server
#
class profile::backup::server (
  String $webui_password,
  String $director_password,
  String $db_password,
  Hash $storages,
  Boolean $manage_nginx_webui    = false,
  Optional[String] $webui_domain = undef,
) {
  $db_name = 'bareos'
  $db_user = 'bareos'

  contain profile::postgresql
  profile::postgresql::db { $db_name:
    user     => $db_user,
    password => $db_password,
    encoding => 'SQL_ASCII',
  }

  contain profile::backup::client

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
    'Differential'    => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => true,
      volume_retention     => '90 days',
      maximum_volume_bytes => '10G',
      maximum_volumes      => 200,
      label_format         => 'Differential-',
    },

    'Full'            => {
      pool_type            => 'Backup',
      recycle              => true,
      auto_prune           => true,
      volume_retention     => '365 days',
      maximum_volume_bytes => '50G',
      maximum_volumes      => 200,
      label_format         => 'Full-',
    },

    'Incremental'     => {
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
    jobdefs           => $job_definitions,
    pools             => $pools,
    storages          => $storages,
    manage_apache     => false,
    webui_password    => $webui_password,
    director_password => $director_password,
    db_name           => $db_name,
    db_user           => $db_user,
    db_password       => $db_password,
  }

  if $manage_nginx_webui {
    contain profile::nginx

    nginx::resource::server { 'bareos-webui':
      server_name => [
        $webui_domain,
      ],
      listen_port => 443,
      format_log  => 'anonymized',
      ssl         => true,
      ssl_cert    => '/etc/ssl/certs/gernox_de.crt',
      ssl_key     => '/etc/ssl/private/gernox_de.key',
      www_root    => '/usr/share/bareos-webui/public',
      try_files   => [
        '$uri',
        '$uri/',
        '/index.php?$query_string',
      ],
      locations   => {
        php => {
          location            => '~ \.php$',
          index_files         => [
            'index.php',
            'index.html',
            'index.htm',
          ],
          fastcgi             => '127.0.0.1:9000',
          fastcgi_param       => {
            'APPLICATION_ENV' => 'production',
          },
          fastcgi_script      => undef,
          location_cfg_append => {
            fastcgi_connect_timeout => '1m',
            fastcgi_read_timeout    => '1m',
            fastcgi_send_timeout    => '1m',
          },
        },
      }
    }
  }
}
