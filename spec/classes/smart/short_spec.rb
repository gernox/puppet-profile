require 'spec_helper'

describe 'profile::smart::short', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/cron.d/smart-short-test')
            .with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '0751',
            )
        }
        it {
          is_expected.to contain_file('/etc/cron.d/smart-short-test')
            .with_content(%r{42 22 \* \* \* root \/usr\/local\/sbin\/smart-test\.sh short >>\/dev\/null})
        }
      end

      describe 'with interval, command and user parameters' do
        let(:params) do
          {
            interval: '1 2 3 4 5',
            command: 'test',
            user: 'foo',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/cron.d/smart-short-test')
            .with_content(%r{1 2 3 4 5 foo test})
        }
      end
    end
  end
end
