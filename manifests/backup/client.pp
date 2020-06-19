# @summary
#   Manages the bareos backup client
#
class profile::backup::client (
) {
  $jobs = {
    # 'default' => {
    #   job_defs     => 'DefaultJob',
    #   schedule_res => 'WeeklyCycle',
    # },
    'aways-incremental'             => {
      job_defs => 'AlwaysIncremental',
    },
    'aways-incremental-consolidate' => {
      job_defs => 'AlwaysIncrementalConsolidate',
    },
    'aways-incremental-long-term'   => {
      job_defs => 'AlwaysIncrementalLongTerm',
    },
  }

  class { '::gernox_bareos::client':
    jobs => $jobs,
  }
}
