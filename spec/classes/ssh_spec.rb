require 'spec_helper'

describe 'profile::ssh', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('profile::ssh::client') }
        it { is_expected.to contain_class('profile::ssh::server') }
        it { is_expected.to have_profile__ssh__keygen_resource_count(0) }
        it { is_expected.to have_profile__ssh__keyscan_resource_count(0) }
      end

      describe 'with keygens_hash parameter' do
        let(:params) do
          {
            keygens_hash: {
              foo: {
              },
              baz: {
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_profile__ssh__keygen_resource_count(2) }
        it { is_expected.to contain_profile__ssh__keygen('foo') }
        it { is_expected.to contain_profile__ssh__keygen('baz') }
      end

      describe 'with keyscans_hash parameter' do
        let(:params) do
          {
            keyscans_hash: {
              foo: {
              },
              bar: {
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_profile__ssh__keyscan_resource_count(2) }
        it { is_expected.to contain_profile__ssh__keyscan('foo') }
        it { is_expected.to contain_profile__ssh__keyscan('bar') }
      end
    end
  end
end
