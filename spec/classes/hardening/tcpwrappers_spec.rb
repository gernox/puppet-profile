require 'spec_helper'

describe 'profile::hardening::tcpwrappers', type: :class do
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
        it { is_expected.to have_file_resource_count(2) }
        it {
          is_expected.to contain_file('/etc/hosts.allow')
            .with(
              ensure: 'file',
              owner: 'root',
              group: 'root',
              mode: '0644',
            )
        }
        it {
          is_expected.to contain_file('/etc/hosts.allow')
            .with_content(%(# File managed by Puppet
sshd:  ALL
rpcbind: ALL
rpcbind: 127.0.0.1 EXCEPT PARANOID
))
        }
        it {
          is_expected.to contain_file('/etc/hosts.deny')
            .with(
              ensure: 'file',
              owner: 'root',
              group: 'root',
              mode: '0644',
            )
        }
        it {
          is_expected.to contain_file('/etc/hosts.deny')
            .with_content(%(# File managed by Puppet
ALL: ALL
))
        }
      end

      describe 'with hosts_allow_template parameter' do
        let(:params) { { hosts_allow_template: '' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_file('/etc/hosts.allow') }
        it { is_expected.to contain_file('/etc/hosts.deny') }
      end

      describe 'with hosts_deny_template parameter' do
        let(:params) { { hosts_deny_template: '' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/hosts.allow') }
        it { is_expected.not_to contain_file('/etc/hosts.deny') }
      end
    end
  end
end
