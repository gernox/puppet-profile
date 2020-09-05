# @summary
#   Manages the postifx mail server to use a relay server
#
# @param root_recipient
#
# @param myorigin
#
# @param mydestination
#
# @param mynetworks
#
# @param smtp_listen
#
# @param relay_host
#
# @param relay_username
#
# @param relay_password
#
class profile::mail::postfix (
  String $root_recipient,
  String $myorigin,
  String $mydestination,
  String $mynetworks,
  String $smtp_listen,

  Optional[String] $relay_host     = undef,
  Optional[String] $relay_username = undef,
  Optional[String] $relay_password = undef,
) {
  class { '::postfix':
    root_mail_recipient => $root_recipient,
    myorigin            => $myorigin,
    smtp_listen         => $smtp_listen,
  }

  postfix::config {
    'mydestination': value => $mydestination;
    'mynetworks': value => $mynetworks;
  }

  if $relay_host != undef {
    $sasl_passwd_path = '/etc/postfix/sasl_passwd';

    postfix::config {
      'relayhost': value => $relay_host;
      'smtp_sasl_auth_enable': value => 'yes';
      'smtp_sasl_security_options': value => 'noanonymous';
      'smtp_sasl_password_maps': value => "hash:${sasl_passwd_path}";
      'smtp_use_tls': value => 'yes';
      'smtp_tls_CAfile': value => '/etc/ssl/certs/ca-certificates.crt';
      'sender_canonical_classes': value => 'envelope_sender, header_sender';
      'sender_canonical_maps': value => 'regexp:/etc/postfix/sender_canonical_maps';
      'smtp_header_checks': value => 'regexp:/etc/postfix/header_check';
    }

    postfix::hash { $sasl_passwd_path:
      ensure  => 'present',
      content => "${relay_host} ${relay_username}:${relay_password}",
    }

    postfix::conffile { 'header_check':
      content => @("EOT")
        # This file is managed by Puppet. DO NOT EDIT.
        /From:.*/ REPLACE From: ${relay_username}
        |EOT
    }

    postfix::conffile { 'sender_canonical_map':
      content => @("EOT")
        # This file is managed by Puppet. DO NOT EDIT.
        /.+/    ${relay_username}
        |EOT
    }

    package { 'libsasl2-modules':
      ensure => present,
      notify => Service['postfix'],
    }
  }
}
