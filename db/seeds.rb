if ENV['RACK_ENV'] == 'development'
  file = File.read('spec/fixtures/sendgrid_multiple_events.json')
  raw_events = JSON.parse(file)

  raw_events.each do |event_json|
    Event.create!(raw: event_json)
  end
end
