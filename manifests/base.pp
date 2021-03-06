# @summary
#   Includes base classes that manage the common baseline resources generally applied to any node
#
# @example
#   Manage common baseline classes
#     profile::base::classes:
#       users: profile::users
#       sudo: profile::sudo
#
# @example
#   Disable inclusion of a class of the given marker
#     profile::base::classes:
#       users: ''
#
# @example
#   Disable the whole class
#     profile::base::manage: false
#
# @param manage
#   If to actually manage any resource
#
# @param classes
#   Hash with a list of classes to include
#
class profile::base (
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
