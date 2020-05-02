require 'spec_helper'

describe 'profile::hardening::pam', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_file_resource_count(0) }
      end

      describe 'with login_defs_template parameter' do
        let(:params) { { login_defs_template: 'profile/hardening/pam/login.defs.erb' } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/login.defs')
            .with(
              ensure: 'file',
              owner: 'root',
              group: 'root',
              mode: '0400',
            )
        }
      end
    end
  end
end
