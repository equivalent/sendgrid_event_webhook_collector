require 'spec_helper'

RSpec.describe Event do
  describe '.process' do
    Given!(:processed_event) do
      create :event, :processed
    end

    Given!(:event) do
      create :event
    end

    Given(:process) do
      described_class.process
    end

    Then do
      expect { process }
        .not_to change { processed_event.reload.processed_at }
    end

    Then do
      expect { process }
        .to change { event.reload.processed_at }
        .from(nil)
        .to be_within(2.seconds).of(Time.now)
    end
  end

  describe '#process' do
    Given(:event) { build :event }

    When { event.process }

    Then do
      event.reload
      expect(event.email).to eq "john.doe@sendgrid.com"
      expect(event.name).to eq "processed"
      expect(event.processed_at).to be_within(2.seconds).of(Time.now)
      expect(event.occurred_at.to_s).to eq "2013-12-10 00:41:52 UTC"
      expect(event.categories).to include('production', 'my_app', 'category3')
    end
  end
end
