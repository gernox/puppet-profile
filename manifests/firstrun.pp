# @summary
#   Special class applied only at first Puppet run
#
# @example
#   Enable firstrun, configure it to set hostname and reboot
#     profile::enable_firstrun: true
#     profile::firstrun::classes:
#       hostname: profile::hostname
#     profile::firstrun::reboot: true
#
# @example
#   Disable firstrun
#     profile::firstrun::manage: false
#
# @param manage
#   If to actually manage any resource
#
# @param classes
#   Hash with a list of classes to include
#
# @param reboot_apply
#   The apply parameter to pass to reboot type
#
# @param reboot_when
#   The when parameter to pass to reboot type
#
# @param reboot_message
#   The message parameter to pass to reboot type
#
# @param reboot_name
#   The name of the reboot type
#
# @param reboot_timeout
#   The timeout parameter to pass to reboot type
#
class profile::firstrun (
  Boolean $manage                               = $::profile::manage,
  Hash $classes                                 = {},
  Boolean $reboot                               = false,
  Enum['immediately', 'finished'] $reboot_apply = 'finished',
  Enum['refreshed', 'pending'] $reboot_when     = 'refreshed',
  String $reboot_message                        = 'firstboot mode enabled, rebooting after first Puppet run',
  String $reboot_name                           = 'Rebooting',
  Integer $reboot_timeout                       = 60,
) {
  if $manage {
    if !empty($classes) {
      $classes.each |$n, $c| {
        if $c != '' {
          contain $c
          Class[$c] -> Profile::Tools::Set_external_fact['firstrun']
        }
      }
    }

    # Reboot
    $fact_notify = $reboot ? {
      false => undef,
      true  => Reboot[$reboot_name],
    }

    profile::tools::set_external_fact { 'firstrun':
      value  => 'done',
      notify => $fact_notify,
    }

    if $reboot {
      reboot { $reboot_name:
        apply   => $reboot_apply,
        message => $reboot_message,
        when    => $reboot_when,
        timeout => $reboot_timeout
      }
    }
  }
}
