require 'spec_helper'

RSpec.describe EventPolicy do
  Given!(:event) { build :event, categories: ['cat', 'car', 'tar'] }
  Given(:user)   { build :user, application_name: 'car' }
  Given(:policy) { described_class.new(user, event) }

  describe '#index?' do
    When(:subject) { policy.index? }
    Then { expect(subject).to be_truthy }
  end

  describe '#show?' do
    When(:subject) { policy.show? }
    Then { expect(subject).to be_truthy }

    context 'when restricted user' do
      Given(:user)   { instance_double(User, application_name: 'dog') }
      Then { expect(subject).to be_falsey }
    end
  end
end

RSpec.describe EventPolicy::Scope do
  Given!(:event1) { create :event, categories: ['cat', 'car', 'tar'] }
  Given!(:event2) { create :event, categories: ['cat','tar'] }
  Given(:user) { build(:user, application_name: 'car') }

  When(:subject) { described_class.new(user, Event.all).resolve }

  Then do
    expect(subject).to     include(event1)
    expect(subject).not_to include(event2)
  end
end
