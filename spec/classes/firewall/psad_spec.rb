require 'spec_helper'

describe 'profile::firewall::psad', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        it { is_expected.to contain_package('psad').with_ensure('installed') }
        it { is_expected.to contain_service('psad') }
        it { is_expected.to contain_file('/etc/psad/psad.conf').that_notifies('Service[psad]') }
        it { is_expected.to contain_file('/etc/psad/auto_dl').that_notifies('Service[psad]') }
      end
    end
  end
end
