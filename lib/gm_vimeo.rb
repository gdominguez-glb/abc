require 'httparty'

class GmVimeo
  PER_PAGE = 30
  ACCESS_TOKEN = ENV['VIMEO_ACCESS_TOKEN']

  def download_videos_json
    endpoint = "https://api.vimeo.com/me/videos"
    page     = 1

    result      = get_result_from_endpoint(endpoint, { query: { page: page, per_page: PER_PAGE } })
    total_pages = calculate_total_pages(result)

    process_videos(result)
    while page <= total_pages do
      page += 1
      result = get_result_from_endpoint(endpoint, { query: { page: page, per_page: PER_PAGE } })
      process_videos(result)
    end
  end

  def process_videos(result)
    videos_data = result['data']
    videos_data.each do |video_data|
      puts "import #{video_data['name']}"

      source_url = video_data['download'].find{|j| j['quality']}.try(:[], 'link')
      next if source_url.blank?

      video = Spree::Video.find_or_create_by(vimeo_uri: video_data['uri'])

      video.update(
        title:       video_data['name']
        description: video_data['description']
        file:        open(source_url)
      )
    end
  end

  def get_result_from_endpoint(endpoint, options)
    headers = { 'Authorization' => "bearer #{ACCESS_TOKEN}" }
    JSON.parse(HTTParty.get(endpoint, options.merge(headers: headers)))
  end

  def calculate_total_pages(result)
    page     = result['page']
    per_page = result['per_page']
    total    = result['total']

    total_pages = total / per_page
    if total % per_page > 0
      total_pages += 1
    end
    total_pages
  end
end
