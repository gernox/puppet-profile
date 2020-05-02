require 'spec_helper'

describe 'profile::shells::zsh', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_ohmyzsh__install('root') }
        it { is_expected.to contain_ohmyzsh__theme('root') }

        it { is_expected.to contain_profile__tools__create_dir('/root/.oh-my-zsh/custom') }
        it { is_expected.to contain_profile__tools__create_dir('/root/.oh-my-zsh/custom/themes') }

        it { is_expected.to contain_file('/root/.oh-my-zsh/custom/puppet.zsh') }
        it { is_expected.to contain_file('/root/.oh-my-zsh/custom/path.zsh') }
        it { is_expected.to contain_file('/root/.oh-my-zsh/custom/aliases.zsh') }
        it { is_expected.to contain_file('/root/.oh-my-zsh/custom/themes/evan.zsh-theme') }
      end
    end
  end
end
