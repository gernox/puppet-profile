# @summary
#   Creates an external fact
#
# @example
#   profile::tools::set_external_fact { 'name':
#     value => 'value',
#   }
#
# @param ensure
#
# @param value
#
# @param template
#
# @param mode
#
# @param options
#
define profile::tools::set_external_fact (
  Enum['absent', 'present'] $ensure = 'present',
  Optional[Any] $value              = undef,
  Optional[String] $template        = undef,
  String $mode                      = '0644',
  Hash $options                     = {},
) {
  if !$value and !$template {
    fail('You must specify either a value or a template to use')
  }

  $external_facts_dir = '/opt/puppetlabs/facter/facts.d';
  $file_content = $value ? {
    undef   => template($template),
    default => "---\n  ${title}: ${value}\n",
  }
  $file_path = $value ? {
    undef   => "${external_facts_dir}/${title}",
    default => "${external_facts_dir}/${title}.yaml",
  }

  if !defined(Profile::Tools::Create_dir[$external_facts_dir]) {
    profile::tools::create_dir { $external_facts_dir:
      before => File[$file_path],
    }
  }

  file { $file_path:
    ensure  => $ensure,
    content => $file_content,
    mode    => $mode,
  }
}
