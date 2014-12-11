require 'spec_helper'
RSpec.describe User do
  Given(:user) { build :user }

  describe 'after create' do
    When { user.save }

    Then { expect(user.errors).to be_empty }

    Then do
      user.reload
      expect(user.token).to be_kind_of String
      expect(user.token.length).to be 40
    end
  end
end
