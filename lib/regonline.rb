require 'httparty'

class Regonline
  API_TOKEN = ENV['regonline_api_token']

  def self.import_events
    Regonline.new.get_events.each do |event_data|
      RegonlineEvent.import(event_data)
    end
    import_events_description
  end

  def self.import_events_description
    regonline = Regonline.new
    RegonlineEvent.find_each do |event|
      description = regonline.get_event_description(event.regonline_id)
      event.update(description: description)
    end
  end

  EVENTS_API = 'https://www.regonline.com/api/default.asmx/GetEvents'
  def get_events
    params = { filter: '', orderBy: '' }
    response = HTTParty.get(EVENTS_API, query: params, headers: default_headers)
    process_response(response)
  end

  EVENTS_API = 'https://www.regonline.com/api/default.asmx/GetEventWebsite'
  def get_event_description(event_id)
    params = { eventID: event_id }
    response = HTTParty.get(EVENTS_API, query: params, headers: default_headers)
    response.parsed_response['ResultsOfListOfEventWebsite']['Data']['APIEventWebsite']['SummaryTab']['CustomContent'] rescue nil
  end

  def process_response(response)
    if response.parsed_response.is_a?(Hash)
      data = response.parsed_response['ResultsOfListOfEvent']['Data']
      Array(data.try(:[], 'APIEvent'))
    else
      []
    end
  end

  def default_headers
    { 'APIToken' => API_TOKEN }
  end
end
