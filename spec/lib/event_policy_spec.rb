require 'ar_spec_helper'

RSpec.describe EventPolicy do
  Given!(:event) do
    build :event, categories: [
      build(:category, value: 'cat'),
      build(:category, value: 'car'),
      build(:category, value: 'tar')
    ]
  end
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
      Given(:user) { build :user, application_name: 'dog' }
      Then { expect(subject).to be_falsey }
    end
  end

  describe '#create?' do
    When(:subject) { policy.create? }
    Then { expect(subject).to be_falsey }

    context 'when user is sendgrid creator' do
      Given(:user) { build :user, :creator }
      Then { expect(subject).to be_truthy }
    end
  end
end

RSpec.describe EventPolicy::Scope do
  Given!(:event1) do
    create :event, categories: [
      create(:category, value: 'cat'),
      create(:category, value: 'car'),
      create(:category, value: 'tar')
    ]
  end

  Given!(:event2) do
    create :event, categories: [
      create(:category, value: 'cat'),
      create(:category, value: 'tar')
    ]
  end

  Given(:user) { build(:user, application_name: 'car') }

  When(:subject) { described_class.new(user, Event.all).resolve }

  Then do
    expect(subject).to     include(event1)
    expect(subject).not_to include(event2)
  end
end
