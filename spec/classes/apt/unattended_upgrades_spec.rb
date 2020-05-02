require 'spec_helper'

describe 'profile::apt::unattended_upgrades', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('unattended-upgrades') }
        it { is_expected.to contain_service('unattended-upgrades') }
        it { is_expected.to contain_file('/etc/apt/apt.conf.d/20auto-upgrades') }
        it { is_expected.to contain_file('/etc/apt/apt.conf.d/50unattended-upgrades') }
      end
    end
  end
end
