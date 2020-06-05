# @summary
#   Installs and configures zsh for the root user
#
# @param manage_zsh_package
#
# @param zsh_package_name
#
class profile::shells::zsh (
  Boolean $manage_zsh_package = false,
  String $zsh_package_name    = 'zsh',
  String $pure_url            = 'https://github.com/sindresorhus/pure.git',
  String $pure_revision       = 'c42bd354943ba4cf2da3ecf493fca4fef0b2722c',
) {
  if $manage_zsh_package {
    package { $zsh_package_name:
      ensure => present,
      before => Ohmyzsh::Install['root'],
    }
  }

  ::ohmyzsh::install { 'root':
    ensure              => present,
    set_sh              => true,
    disable_auto_update => true,
  }

  profile::tools::create_dir { '/root/.oh-my-zsh/custom': }

  file { '/root/.oh-my-zsh/custom/zsh_completion.zsh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('profile/shells/zsh/zsh_completion.zsh'),
    require => Profile::Tools::Create_dir['/root/.oh-my-zsh/custom'],
  }

  file { '/root/.oh-my-zsh/custom/puppet.zsh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'export PATH="/opt/puppetlabs/bin:$PATH"',
    require => Profile::Tools::Create_dir['/root/.oh-my-zsh/custom'],
  }

  file { '/root/.oh-my-zsh/custom/aliases.zsh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('profile/shells/zsh/aliases.zsh'),
    require => Profile::Tools::Create_dir['/root/.oh-my-zsh/custom'],
  }

  file { '/root/.oh-my-zsh/custom/pure.zsh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('profile/shells/zsh/pure.zsh'),
    require => Profile::Tools::Create_dir['/root/.oh-my-zsh/custom'],
  }

  vcsrepo { '/root/.oh-my-zsh/custom/pure':
    ensure   => present,
    provider => git,
    source   => $pure_url,
    revision => $pure_revision,
    require  => Profile::Tools::Create_dir['/root/.oh-my-zsh/custom'],
  }
}
