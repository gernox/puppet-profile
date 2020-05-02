require 'spec_helper'

describe 'profile::hostname', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      describe 'by default' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/hostname') }
        it { is_expected.to contain_exec('apply_hostname').with_command('/bin/hostname -F /etc/hostname') }
      end

      describe 'with custom hostname and ip' do
        let(:params) do
          {
            host: 'host',
            domain: 'test',
            ip: '192.168.1.1',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/hostname').with_content("host.test\n") }
        it { is_expected.to contain_host('host').with_ip('192.168.1.1') }
      end

      describe 'with unsupported ::kernel' do
        let(:facts) do
          os_facts.merge(
            'kernel' => 'windows',
          )
        end

        print os_facts

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_file('/etc/hsotname') }
        it { is_expected.not_to contain_exec('apply_hostname') }
      end
    end
  end
end
