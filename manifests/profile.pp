# @summary
#   Manages /etc/profile and relevant files
#
# @param template
#
# @param add_tz_optimization
#
class profile::profile (
  String $template             = '',
  Boolean $add_tz_optimization = true,
) {
  if $template != '' {
    file { '/etc/profile':
      content => template($template),
    }
  }

  $tz_optimization_ensure = $add_tz_optimization ? {
    true    => 'file',
    default => 'absent',
  }

  file { '/etc/profile.d/tz.sh':
    ensure  => $tz_optimization_ensure,
    content => template('profile/profile/tz.sh.erb'),
  }
}
