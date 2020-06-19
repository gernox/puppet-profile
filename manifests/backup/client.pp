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
    },
    'aways-incremental-consolidate' => {
    },
    'aways-incremental-long-term'   => {
    },
  }

  class { '::gernox_bareos::client':
    jobs => $jobs,
  }
}
