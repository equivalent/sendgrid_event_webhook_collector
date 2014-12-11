require 'spec_helper'
RSpec.describe User do
  Given(:user) { described_class.new }

  describe 'after create' do
    Given(:user) { build :user }
    When { user.save }

    Then { expect(user.errors).to be_empty }

    Then do
      user.reload
      expect(user.token).to be_kind_of String
      expect(user.token.length).to be 40
    end
  end

  describe '.find_param' do
    Given(:subject) { User.find_param(token) }

    context 'when token is nil' do
      Given(:token) { nil }
      Then { is_expected.to be nil }
    end

    context 'when token is existing user token' do
      Given(:token) { user.token }
      When(:user) { create :user, token: 'abc' }
      Then { is_expected.to eq user }
    end
  end
end
