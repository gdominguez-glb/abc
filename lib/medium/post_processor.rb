module Medium
  class PostProcessor
    def initialize(opts={})
      @data = opts[:data]
      @url  = opts[:url]
    end

    def process
      return {} if @data['success'] != true
      value = @data['payload']['value']

      published_at    = Time.at(value['firstPublishedAt']/1000)
      body            = process_paragraphs(value['content']['bodyModel']['paragraphs'])
      preview_content = process_preview_paragraphs(value['previewContent']['bodyModel']['paragraphs'], value['title'])

      {
        medium_id:       value['id'],
        title:           value['title'],
        subtitle:        value['content']['subtitle'],
        published_at:    published_at,
        body:            body,
        preview_content: preview_content
      }
    end

    def process_paragraphs(paragraphs)
      Medium::ParagraphsProcessor.new(paragraphs: paragraphs[1..-1], url: @url).process
    end

    def process_preview_paragraphs(paragraphs, title)
      self.process_paragraphs(paragraphs.reject { |p| p["text"] == title and p["name"] == "previewTitle" })
    end
  end
end
