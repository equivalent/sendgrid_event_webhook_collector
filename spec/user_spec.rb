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
end
