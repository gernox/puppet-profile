require 'spec_helper'

describe 'profile::hardening::services', type: :class do
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
        it { is_expected.to have_service_resource_count(0) }
      end

      describe 'with services_to_remove parameter' do
        let(:params) do
          {
            services_to_remove: ['test'],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_service_resource_count(1) }
        it {
          is_expected.to contain_service('test')
            .with(
              ensure: 'stopped',
              enable: false,
            )
        }
      end

      describe 'with services_default parameter' do
        let(:params) do
          {
            services_default: ['foo'],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_service_resource_count(1) }
        it {
          is_expected.to contain_service('foo')
            .with(
              ensure: 'stopped',
            )
        }
      end

      describe 'with services_to_remove and services_default parameters' do
        let(:params) do
          {
            services_to_remove: ['foo'],
            services_default: ['bar'],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_service_resource_count(2) }
        it {
          is_expected.to contain_service('foo')
            .with(
              ensure: 'stopped',
            )
        }
        it {
          is_expected.to contain_service('bar')
            .with(
              ensure: 'stopped',
            )
        }
      end

      describe 'with remove_default_services parameter' do
        let(:params) do
          {
            services_default: ['test'],
            remove_default_services: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_service_resource_count(0) }
        it { is_expected.not_to contain_service('test') }
      end
    end
  end
end
