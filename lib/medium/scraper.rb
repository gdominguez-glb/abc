module Medium
  class Scraper
    def scrape_publications
      puts 'start importing posts from medium'
      MediumPublication.find_each do |publication|
        scrape!(publication)
      end
      puts
      puts 'finished'
    end

    def scrape!(publication, limit = nil)
      begin
        url = publication.url + '/latest'
        url = url + "?limit=#{limit}" unless limit.nil?

        publication_data = request_data_from_medium(url)
        publication_data['payload']['posts'].each do |post|
          print '.'
          import_post_from_medium(publication, post)
        end
        remove_deleted_posts(publication, publication_data['payload']['posts'])
      rescue
        puts
        puts 'failed to import posts from medium'
      end
    end

    def import_post_from_medium(publication, post_json)
      post_url  = construct_post_url(publication, post_json)
      post_data = request_data_from_medium(post_url)
      post_hash = PostProcessor.new(data: post_data, url: post_url).process
      return if post_hash[:medium_id].blank?
      post      = publication.posts.find_or_initialize_by(medium_id: post_hash[:medium_id])
      post.update(post_hash.merge(medium_publication_id: publication.id))
    end

    def remove_deleted_posts(publication, medium_posts)
      if medium_posts.size == 0
        publication.posts.destroy_all
        return
      end
      from_at = Time.at(medium_posts[0]['firstPublishedAt']/1000)
      to_at   = Time.at(medium_posts[-1]['firstPublishedAt']/1000)
      titles  = medium_posts.map {|p| p['title'] }
      publication.posts.where.not(title: titles).where('published_at between ? and ?', from_at, to_at).destroy_all
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
