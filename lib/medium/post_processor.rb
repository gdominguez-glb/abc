module Medium
  class PostProcessor
    include ActionView::Helpers::TagHelper

    def initialize(opts={})
      @data = opts[:data]
    end

    def process
      return {} if @data['success'] != true
      title        = @data['payload']['value']['title']
      subtitle     = @data['payload']['value']['content']['subtitle']
      medium_id    = @data['payload']['value']['id']
      published_at = Time.at(@data['payload']['value']['latestPublishedAt']/1000)

      paragraphs   = @data['payload']['value']['content']['bodyModel']['paragraphs']
      body         = Medium::ParagraphsProcessor.new(paragraphs: paragraphs[1..-1]).process

      preview_paragraphs = @data['payload']['value']['previewContent']['bodyModel']['paragraphs']
      preview_content    = Medium::ParagraphsProcessor.new(paragraphs: preview_paragraphs[1..-1]).process
      {
        medium_id: medium_id,
        published_at: published_at,
        title: title,
        subtitle: subtitle,
        body: body,
        preview_content: preview_content
      }
    end

  end
end
