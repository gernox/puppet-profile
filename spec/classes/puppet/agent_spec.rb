require 'spec_helper'

describe 'profile::puppet::agent', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(serverversion: '6.10.0')
      end

      let(:params) do
        {
          puppet_server: 'puppet.dev',
          run_interval: '1d',
          last_run_file: '/last_run_file',
        }
      end

      context 'compile' do
        it { is_expected.to contain_class('puppet_agent') }
        it {
          is_expected.to contain_file('/etc/apt/sources.list.d/puppet6.list')
            .with(
              ensure: 'absent',
            )
        }
        it { is_expected.to contain_file('/etc/logrotate.d/puppet-agent') }
        it {
          is_expected.to contain_service('pxp-agent')
            .with(
              enable: false,
            )
        }
        it {
          is_expected.to contain_file('/etc/logrotate.d/pxp-agent')
            .with(
              ensure: 'absent',
            )
        }
        it { is_expected.to compile.with_all_deps }
      end

      context 'agent configuration' do
        it {
          is_expected.to contain_ini_setting('puppet agent server')
            .with(
              value: 'puppet.dev',
            )
        }
        it {
          is_expected.to contain_ini_setting('puppet agent strict variable checking')
            .with(
              value: true,
            )
        }
        it {
          is_expected.to contain_ini_setting('puppet agent runinterval')
            .with(
              value: '1d',
            )
        }
        it {
          is_expected.to contain_ini_setting('puppet agent lastrunfile')
            .with(
              value: '/last_run_file',
            )
        }
      end
    end
  end
end
