require 'nokogiri'

module Medium
  class FigureProcessor
    def initialize(opts = {})
      @paragraph = opts[:paragraph]
      @url       = opts[:url]
    end

    def process
      url = extract_image_url
      return '' if url.blank?
      construct_figure_html(url)
    end

    def construct_figure_html(image_url)
      <<-HTML
        <figure>
          <div>
            <img src='#{image_url}' class='post-image'/>
          </div>
          <figcaption class="imageCaption">#{@paragraph['text']}</figcaption>
        </figure>
      HTML
    end

    def extract_image_url
      html     = HTTParty.get(@url, parser: nil).body
      html_doc = Nokogiri::HTML(html)
      element  = html_doc.xpath("//img[@data-image-id = '#{@paragraph['metadata']['id']}']")[0]
      element.try(:[], 'src')
    end
  end
end
