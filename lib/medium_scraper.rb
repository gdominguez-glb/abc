require 'httparty'

class MediumScraper
  def scape_publications
    MediumPublication.all.each do |publication|
      begin
        response = HTTParty.get(publication.url + '/latest', query: { format: 'json' }, parser: nil)
        publication_data = convert_to_json(response.body)
        publication_data['payload']['posts'].each do |post|
          slug            = post['slug']
          post_url        = publication.url + '/' + slug + '-' + post['id']
          post_response   = HTTParty.get(post_url, query: { format: 'json' }, parser: nil)
          post_data       = convert_to_json(post_response.body)
          post_paragraphs = post_data['payload']['value']['content']['bodyModel']['paragraphs']
          puts post_paragraphs.count
        end
      rescue
      end
    end
  end

  def convert_to_json(response_body)
    JSON.parse(response_body[16..-1])
  rescue
    {}
  end
end
