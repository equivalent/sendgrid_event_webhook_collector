require 'ar_spec_helper'

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

    When do
      create :whitelist_argument, name: 'tag_my2'
      create :whitelist_argument, name: 'id'
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

    Then do
      num_categories = 3
      num_custom_arg = 2
      num_sendgrid_args = 2

      expect { process }
        .to change { event.arguments.count }
        .by(num_categories + num_sendgrid_args + num_custom_arg)
    end
  end
end
