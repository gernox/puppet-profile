require 'spec_helper'

describe 'profile::users', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::users') }

      describe 'not passing parameters' do
        describe 'Root user is not created'
        it { is_expected.not_to contain_user('root') }

        describe 'No users are created'
        it { is_expected.to have_user_resource_count(0) }

        describe 'Unmanaged users are not purged'
        it { is_expected.to have_profile__users__managed_resource_count(0) }
      end

#      describe 'with root_pw parameter' do
#        let(:params) { { root_pw: 'test-pw' } }
#
#        describe 'Root user is created'
#        it {
#          is_expected.to contain_user('root')
#            .with(
#              password: 'test-pw',
#            )
#        }
#      end

      describe 'with delete_unmanaged parameter' do
        let(:params) { { delete_unmanaged: true } }

        describe 'Non-system users are purged'
        it {
          is_expected.to contain_resources('user')
            .with(
              purge: true,
              unless_system_user: true,
            )
        }
      end

      describe 'with users_hash parameter' do
        let(:params) do
          {
            users_hash: {
              test_user1: {
                name: 'user1',
              },
              test_user2: {
                name: 'user2',
              },
            },
          }
        end

        it { is_expected.to have_user_resource_count(2) }
      end

      describe 'with users_hash and module parameters' do
        let(:params) do
          {
            users_hash: {
              test_user1: {
                name: 'user1',
              },
            },
            module: 'accounts',
          }
        end

        it { is_expected.to have_accounts__user_resource_count(1) }
      end

      describe 'with available_users_hash parameter' do
        let(:params) do
          {
            available_users_hash: {
              user1: {
                name: 'user1',
              },
            },
          }
        end

        it { is_expected.to have_user_resource_count(0) }
      end

      describe 'with available_users_hash and available_users_to_add parameters' do
        let(:params) do
          {
            available_users_hash: {
              user1: {
                name: 'user1',
              },
            },
            available_users_to_add: [
              'user1',
            ],
          }
        end

        it { is_expected.to have_user_resource_count(1) }
      end

#      describe 'with invalid parameter values' do
#        describe 'root_pw cannot be empty string' do
#          let(:params) { { root_pw: '' } }
#
#          it { is_expected.to raise_error(Puppet::PreformattedError, %r{/^Evaluation Error:.*/}) }
#        end
#      end
    end
  end
end
