require 'spec_helper'

describe 'profile::editors::vim', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_profile__tools__create_dir_resource_count(2) }
        it { is_expected.to contain_profile__tools__create_dir('/root/.vim/bundle') }
        it { is_expected.to contain_profile__tools__create_dir('/root/.vim/autoload') }
        it { is_expected.to contain_vcsrepo('/root/.vim/bundle/vim-colors') }
        it {
          is_expected.to contain_file('/root/.vimrc')
            .with_source('puppet:///modules/profile/editors/vim/root.rc')
        }
      end
    end
  end
end
