# @summary
#   Manages profiles specific to nodes, roles or any other group
#
# @example
#   Manage common profile classes
#     profile::profiles::classes:
#       webserver: gernox_nginx
#
# @example
#   Disable inclusion of a class of the given marker
#     profile::profiles::classes:
#       webserver: ''
#
# @example
#   Disable the whole class
#     profile::profiles::manage: false
#
# @param manage
#   If to actually manage any resource
#
# @param classes
#   Hash with a list of classes to include
#
class profile::profiles (
  Boolean $manage = $::profile::manage,
  Hash $classes   = {},
) {
  if $manage {
    if !empty($classes) {
      $classes.each |$n, $c| {
        if $c != '' {
          contain $c
        }
      }
    }
  }
}
