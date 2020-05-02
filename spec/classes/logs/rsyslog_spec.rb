require 'spec_helper'

describe 'profile::logs::rsyslog', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('rsyslog') }
        it { is_expected.to contain_service('rsyslog') }
        it {
          is_expected.to contain_file('/etc/rsyslog.conf')
            .with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '0644',
              source: 'puppet:///modules/profile/logs/rsyslog/rsyslog.conf',
            )
        }
      end
    end
  end
end
