require 'spec_helper'

describe 'profile::profile', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/profile.d/tz.sh')
            .with(
              ensure: 'file',
            )
        }
      end

      describe 'with template parameter' do
        let(:params) { { template: 'profile/profile/profile.erb' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/profile') }
      end

      describe 'with add_tz_optimization parameter' do
        let(:params) { { add_tz_optimization: false } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/profile.d/tz.sh')
            .with(
              ensure: 'absent',
            )
        }
      end
    end
  end
end
