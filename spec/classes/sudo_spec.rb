require 'spec_helper'

describe 'profile::sudo', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_file('/etc/sudoers') }
        it {
          is_expected.to contain_file('/etc/sudoers.d')
            .with(
              ensure: 'directory',
              owner: 'root',
              group: 'root',
              mode: '0440',
              recurse: true,
              purge: false,
            )
        }
        it { is_expected.to have_profile__sudo__directive_resource_count(0) }
      end

      describe 'with sudoers_template parameter' do
        let(:params) { { sudoers_template: 'profile/sudo/sudoers.erb' } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/sudoers')
            .with(
              ensure: 'file',
              owner: 'root',
              group: 'root',
              mode: '0440',
            )
        }
        it {
          is_expected.to contain_file('/etc/sudoers.broken')
            .with(
              ensure: 'absent',
            )
        }
        it { is_expected.to contain_exec('sudo_syntax_check') }
      end

      describe 'with sudoers_template and admins parameters' do
        let(:params) do
          {
            sudoers_template: 'profile/sudo/sudoers.erb',
            admins: [
              'adminfoo',
              'adminbar',
            ],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/sudoers')
            .with_content(%r{^User_Alias      ADMINS = adminfoo,adminbar$})
        }
      end

      describe 'with sudoers_d_source parameter' do
        let(:params) { { sudoers_d_source: '/tmp' } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/sudoers.d')
            .with(
              source: '/tmp',
            )
        }
      end

      describe 'with purge_sudoers_dir parameter' do
        let(:params) { { purge_sudoers_dir: true } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/sudoers.d')
            .with(
              purge: true,
            )
        }
      end

      describe 'with directives parameter' do
        let(:params) do
          {
            directives: {
              foo: {
              },
              bar: {
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_profile__sudo__directive_resource_count(2) }
        it { is_expected.to contain_profile__sudo__directive('foo') }
        it { is_expected.to contain_profile__sudo__directive('bar') }
      end
    end
  end
end
