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
) {
  if $manage_zsh_package {
    package { $zsh_package_name:
      ensure => present,
      before => Ohmyzsh::Install['root'],
    }
  }

  ::ohmyzsh::install { 'root':
    set_sh              => true,
    disable_auto_update => true,
  }

  ::ohmyzsh::theme { 'root':
    theme => 'evan',
  }

  profile::tools::create_dir { '/root/.oh-my-zsh/custom': }
  -> profile::tools::create_dir { '/root/.oh-my-zsh/custom/themes': }

  file { '/root/.oh-my-zsh/custom/puppet.zsh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('profile/shells/zsh/zsh_completion.zsh'),
    require => Profile::Tools::Create_dir['/root/.oh-my-zsh/custom'],
  }

  file { '/root/.oh-my-zsh/custom/path.zsh':
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

  file { '/root/.oh-my-zsh/custom/themes/evan.zsh-theme':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('profile/shells/zsh/evan-theme-override.zsh'),
    require => Profile::Tools::Create_dir['/root/.oh-my-zsh/custom/themes'],
  }
}
