require 'spec_helper'

describe 'profile::mail::postfix', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) do
        {
          root_recipient: 'root@localhost'
        }
      end

      context 'compile' do
        it { is_expected.to contain_class('postfix') }
        it { is_expected.to compile.with_all_deps }
      end

      context 'using a relay server' do
        let(:params) do
          super().merge({
            relay_host: '127.0.0.1',
            relay_username: 'username',
            relay_password: 'password',
          })
        end

        context 'compile' do
          it { is_expected.to contain_package('libsasl2-modules') }
          it { is_expected.to compile.with_all_deps }
        end
      end
    end
  end
end
