require 'spec_helper'

describe 'profile::smart', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/usr/local/sbin/smart-test.sh')
            .with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '0751',
              source: 'puppet:///modules/profile/smart/smart-test.sh',
            )
        }
        it { is_expected.to contain_class('profile::smart::short') }
        it { is_expected.to contain_class('profile::smart::long') }
      end
    end
  end
end
