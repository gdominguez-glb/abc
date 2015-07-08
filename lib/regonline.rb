require 'httparty'

class Regonline
  API_TOKEN = ENV['regonline_api_token']

  def self.import_events
    Regonline.new.get_events.each do |event_data|
      RegonlineEvent.import(event_data)
    end
  end

  EVENTS_API = 'https://www.regonline.com/api/default.asmx/GetEvents'
  def get_events
    params = { filter: '', orderBy: '' }
    response = HTTParty.get(EVENTS_API, query: params, headers: default_headers)
    process_response(response)
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
