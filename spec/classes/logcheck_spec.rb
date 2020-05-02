require 'spec_helper'

describe 'profile::logcheck', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('logcheck') }
        it {
          is_expected.to contain_file('/etc/logcheck/ignore.d.server')
            .with(
              ensure: 'directory',
              owner: 'root',
              group: 'logcheck',
              mode: '0644',
              purge: false,
              recurse: true,
              source: 'puppet:///modules/profile/logcheck/ignore.d.server',
            )
        }
        it {
          is_expected.to contain_file('/etc/logcheck/violations.ignore.d')
            .with(
              ensure: 'directory',
              owner: 'root',
              group: 'logcheck',
              mode: '0644',
              purge: true,
              recurse: true,
              source: 'puppet:///modules/profile/logcheck/violations.ignore.d',
            )
        }
      end
    end
  end
end
