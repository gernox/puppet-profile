require 'spec_helper'

describe 'profile::foobar', type: :class do
  describe 'On a linux system' do
    it 'does not fail' do
      is_expected.not_to raise_error
    end
    it { is_expected.to contain_file('/etc/foobar') }
  end
end
