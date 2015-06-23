require 'httparty'

class Regonline
  API_TOKEN = 'OO5NcLPlqn+YvxhnCHJYdx41BUbb+GpaYkjCNMIC7ycS1KazFUokDQ=='

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
