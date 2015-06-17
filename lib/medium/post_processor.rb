module Medium
  class PostProcessor
    include ActionView::Helpers::TagHelper

    def initialize(opts={})
      @data = opts[:data]
    end

    def process
      return {} if @data['success'] != true
      paragraphs   = @data['payload']['value']['content']['bodyModel']['paragraphs']
      title        = @data['payload']['value']['title']
      subtitle     = @data['payload']['value']['content']['subtitle']
      medium_id    = @data['payload']['value']['id']
      published_at = Time.at(@data['payload']['value']['latestPublishedAt']/1000)
      {
        medium_id: medium_id,
        published_at: published_at,
        title: title,
        subtitle: subtitle,
        body: Medium::ParagraphsProcessor.new(paragraphs: paragraphs).process
      }
    end

  end
end
