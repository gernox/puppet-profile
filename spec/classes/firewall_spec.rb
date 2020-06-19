require 'spec_helper'

describe 'profile::firewall', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) do
        {
          system_rules: {
            :'101 - IPv4: allow https access' => {
              dport: '443',
              proto: 'tcp',
              action: 'accept',
            },
            :'101 - IPv6: allow https access' => {
              dport: '443',
              proto: 'tcp',
              action: 'accept',
              provider: 'ip6tables',
            },
          },
        }
      end

      context 'compile' do
        it { is_expected.to contain_class('firewall') }
        it { is_expected.to compile.with_all_deps }
      end

      context 'allows ssh connections' do
        it {
          is_expected.to contain_firewall('100 - IPv4: allow ssh access')
            .with(
              dport: 22,
              proto: 'tcp',
              action: 'accept',
            )
        }
        it {
          is_expected.to contain_firewall('100 - IPv6: allow ssh access')
            .with(
              dport: 22,
              proto: 'tcp',
              action: 'accept',
              provider: 'ip6tables',
            )
        }
      end

      context 'creates firewall rules' do
        it { is_expected.to contain_firewall('101 - IPv4: allow https access') }
        it { is_expected.to contain_firewall('101 - IPv6: allow https access') }
      end
    end
  end
end
