# @summary
#   Includes prerequisite classes, applied before base classes and profiles
#
# @example Manage prerequisite classes
#    profile::pre::classes:
#      users: profile::users
#
# @example Disable incluse of a class of the given marker
#    profile::pre::classes:
#      users: ''
#
# @example Disable the whole class
#    profile::pre::manage: false
#
# @param manage
#   If to actually manage any resource
#
# @param classes
#   Hash with a list of classes to include
#
class profile::pre (
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
