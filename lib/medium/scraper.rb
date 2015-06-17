module Medium
  class Scraper
    def scrape_publications
      MediumPublication.all.each do |publication|
        begin
          response = HTTParty.get(publication.url + '/latest', query: { format: 'json' }, parser: nil)
          publication_data = convert_to_json(response.body)
          publication_data['payload']['posts'].each do |post|
            slug          = post['slug']
            post_url      = publication.url + '/' + slug + '-' + post['id']
            post_response = HTTParty.get(post_url, query: { format: 'json' }, parser: nil)
            post_data     = convert_to_json(post_response.body)
            post_hash     = PostProcessor.new(data: post_data).process
            post          = Post.find_or_initialize_by(medium_id: post_hash[:medium_id])
            post.update(post_hash.merge(medium_publication_id: publication.id))
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
end
