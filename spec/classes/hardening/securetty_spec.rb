require 'spec_helper'

describe 'profile::hardening::securetty', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('profile::hardening::securetty') }
      end

      describe 'not passing parameters' do
        let(:params) { {} }

        it {
          is_expected.to contain_file('/etc/securetty')
            .with(
              ensure: 'file',
              owner: 'root',
              group: 'root',
              mode: '0400',
            )
        }
        it {
          is_expected.to contain_file('/etc/securetty')
            .with_content(%(# File managed by Puppet
console
tty1
tty2
tty3
tty4
tty5
tty6
))
        }
      end

      describe 'passing root_ttys parameter' do
        let(:params) { { root_ttys: ['foo'] } }

        it {
          is_expected.to contain_file('/etc/securetty')
            .with_content(%(# File managed by Puppet
foo
))
        }
      end
    end
  end
end
