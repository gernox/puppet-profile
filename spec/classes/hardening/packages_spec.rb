require 'spec_helper'

describe 'profile::hardening::packages', type: :class do
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
        it { is_expected.to have_packages_resource_count(0) }
      end

      describe 'with packages_to_remove parameter' do
        let(:params) { { packages_to_remove: ['test'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_package_resource_count(1) }
        it {
          is_expected.to contain_package('test')
            .with(
              ensure: 'absent',
            )
        }
      end

      describe 'with packages_default parameter' do
        let(:params) { { packages_default: ['foo'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_package_resource_count(1) }
        it {
          is_expected.to contain_package('foo')
            .with(
              ensure: 'absent',
            )
        }
      end

      describe 'with packages_to_remove and packages_default parameters' do
        let(:params) do
          {
            packages_to_remove: ['foo'],
            packages_default: ['bar'],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_package_resource_count(2) }
        it {
          is_expected.to contain_package('foo')
            .with(
              ensure: 'absent',
            )
        }
        it {
          is_expected.to contain_package('bar')
            .with(
              ensure: 'absent',
            )
        }
      end

      describe 'with remove_default_packages parameter' do
        let(:params) do
          {
            packages_default: ['test'],
            remove_default_packages: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_package_resource_count(0) }
        it { is_expected.not_to contain_package('test') }
      end
    end
  end
end
