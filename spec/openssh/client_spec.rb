require 'spec_helper'

describe 'profile::ssh::client', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      describe 'without passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('ssh::client') }
      end

      describe 'passing ssh_options parameter' do
        let(:params) { { ssh_options: {} } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_class('ssh::client')
            .with(
              options: {},
            )
        }
      end
    end
  end
end
