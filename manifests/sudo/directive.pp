# @summary
#   Generates sudo directives
#
# @param ensure
#   If the fragment should be present (default) or absent
#
# @param content
#   Sets the value of content parameter for the sudo fragment. Can be set as an array (joined with newlines)
#
# @param template
#   Sets the value of content parameter for the sudo fragment. This is alternative to the source one
#
# @param source
#   Sets the value of source parameter for the sudo fragment.
#
# @param order
#   Sets the order of the fragment inside /etc/sudoers or /etc/sudoers.d. Default 20
#
define profile::sudo::directive (
  Enum['present', 'absent'] $ensure = present,
  Variant[Undef, String] $content   = undef,
  Variant[Undef, String] $template  = undef,
  Variant[Undef, String] $source    = undef,
  Integer $order                    = 20,
) {
  # sudo is skipping file names that contain a '.'
  $dname = regsubst($name, '\.', '-', 'G')

  $base_name = "/etc/sudoers.d/${order}_${dname}"

  $real_content = $content ? {
    undef   => $template ? {
      undef   => undef,
      default => template($template),
    },
    default => inline_template('<%= [@content].flatten.join("\n") + "\n" %>'),
  }

  $syntax_check = $ensure ? {
    'present' => Exec["sudo-syntax-check for file ${base_name}"],
    default   => undef,
  }

  file { $base_name:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => $real_content,
    source  => $source,
    notify  => $syntax_check,
  }

  # Remove the .broken file which can be left over by the sudo-syntax-check
  file { "${base_name}.broken":
    ensure => absent,
    before => $syntax_check,
  }

  if $ensure == 'present' {
    exec { "sudo-syntax-check for file ${base_name}":
      command     => "visudo -c -f ${base_name} || ( mv -f ${base_name} ${base_name}.broken && exit 1 )",
      refreshonly => true,
      path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    }
  }
}
