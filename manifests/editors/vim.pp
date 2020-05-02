# @summary
#   Manages DNS resolver configuration in /etc/resolv.conf
#
# @param nameservers
#
# @param options
#
# @param resolver_config_file
#
# @param resolver_config_file_ensure
#
# @param resolver_config_file_owner
#
# @param resolver_config_file_group
#
# @param resolver_config_file_mode
#
# @param search
#
# @param domain
#
# @param sortlist
#
class profile::editors::vim (
  String $theme_url,
  String $theme_revision,
  String $pathogen_url,
  String $pathogen_revision,
) {
  contain ::vim

  profile::tools::create_dir { '/root/.vim/bundle': }
  profile::tools::create_dir { '/root/.vim/autoload': }

  vcsrepo { '/root/.vim/bundle/vim-colors':
    ensure   => present,
    provider => git,
    source   => $theme_url,
    revision => $theme_revision,
    require  => Profile::Tools::Create_dir['/root/.vim/bundle'],
  }

  file { '/root/.vimrc':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/profile/editors/vim/root.rc',
    require => Profile::Tools::Create_dir['/root/.vim/bundle'],
  }

  vcsrepo { '/tmp/pathogen':
    ensure   => present,
    provider => git,
    source   => $pathogen_url,
    revision => $pathogen_revision,
    require  => Profile::Tools::Create_dir['/root/.vim/autoload'],
  }
  -> exec { 'vim copy pathogen':
    command => '/bin/cp /tmp/pathogen/autoload/pathogen.vim /root/.vim/autoload/pathogen.vim',
    creates => '/root/.vim/autoload/pathogen.vim',
  }
}
