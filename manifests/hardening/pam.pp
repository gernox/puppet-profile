# @summary
#   Manages PAM settings
#
# @example To set password age settings
#    profile::hardening::pam::login_defs_template: profile/hardening/pam/login.defs.erb
#    profile::hardening::pam::options:
#      password_max_age: 30
#      password_min_age: 7
#
# @param system_auth_template
#   Path of the template used to manage the content of pam system-auth.
#
# @param password_auth_template
#   Path of the template used to manage the content of pam password-auth.
#
# @param login_defs_template
#   Path of the template used to manage the content of /etc/login.defs
#
# @param options
#   An open hash of options to be used in the provided templates.
#
class profile::hardening::pam (
  String $system_auth_template   = '',
  String $password_auth_template = '',
  String $login_defs_template    = '',
  Hash $options                  = {},
) {
  $options_default = {
    umask                    => '027',
    password_max_age         => 60,
    password_min_age         => 7,
    password_warb_age        => 7,
    ttygroup                 => 'tty',
    ttyperm                  => '0600',
    uid_min                  => 1000,
    uid_max                  => 60000,
    gid_min                  => 1000,
    gid_max                  => 60000,
    encrypt_method           => 'SHA512',
    login_retries            => 5,
    login_timeout            => 60,
    sha_crypt_max_rounds     => 10000,
    chfn_restrict            => '',
    allow_login_without_home => false,
    additional_user_paths    => '',
  }
  $_options = merge($options_default, $options)

  $_system_auth_template = $system_auth_template ? {
    ''      => "profile/hardening/pam/system_auth_${::osfamily}${::operatingsystemmajrelease}",
    default => $system_auth_template,
  }
  $_password_auth_template = $password_auth_template ? {
    ''      => "profile/hardening/pam/password-auth_${::osfamily}${::operatingsystemmajrelease}",
    default => $password_auth_template,
  }

  if $login_defs_template != '' {
    file { '/etc/login.defs':
      ensure  => file,
      content => template($login_defs_template),
      owner   => 'root',
      group   => 'root',
      mode    => '0400',
    }
  }

  # TODO
  if ( $::os['family'] == 'RedHat' and $::os['release']['major'] == '7' ) {
    file { '/etc/pam.d/system-auth-ac':
      content => template($_system_auth_template),
    }

    file { '/etc/pam.d/password-auth-ac':
      content => template($_password_auth_template),
    }
  }
}
