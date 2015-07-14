module Medium
  class Scraper
    def scrape_publications
      MediumPublication.find_each do |publication|
        begin
          publication_data = request_data_from_medium(publication.url + '/latest')
          publication_data['payload']['posts'].each do |post|
            import_post_from_medium(publication, post)
          end
        rescue
        end
      end
    end

    def import_post_from_medium(publication, post_json)
      post_url  = construct_post_url(publication, post_json)
      post_data = request_data_from_medium(post_url)
      post_hash = PostProcessor.new(data: post_data, url: post_url).process
      return if post_hash[:medium_id].blank?
      post      = Post.find_or_initialize_by(medium_id: post_hash[:medium_id])
      post.update(post_hash.merge(medium_publication_id: publication.id))
    end

    def request_data_from_medium(url)
      response = HTTParty.get(url, query: { format: 'json' }, parser: nil)
      convert_to_json(response.body)
    end

    def construct_post_url(publication, post)
      publication.url + '/' + post['slug'] + '-' + post['id']
    end

    def convert_to_json(response_body)
      JSON.parse(response_body[16..-1])
    rescue
      {}
    end
  end
end
