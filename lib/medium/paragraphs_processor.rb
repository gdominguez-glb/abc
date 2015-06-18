module Medium
  class ParagraphsProcessor
    def initialize(opts = {})
      @paragraphs = opts[:paragraphs]
      @url        = opts[:url]
    end

    def process
      @paragraphs.map do |paragraph|
        if paragraph['type'] == FIGURE_TAG_TYPE
          process_figure(paragraph)
        else
          process_paragraph(paragraph)
        end
      end.join("\n")
    end

    # keys: name, type, text, markups: [type, start, end]
    def process_paragraph(paragraph)
      type    = paragraph['type']
      text    = paragraph['text']
      markups = paragraph['markups']
      tag     = PARAGRAPH_TYPES[type]
      "<#{tag}>#{MarkupsProcessor.new(text: text, markups: markups).process}</#{tag}>"
    end

    def process_figure(paragraph)
      FigureProcessor.new(url: @url, paragraph: paragraph).process
    end

    def paragraph_tag(type)
      PARAGRAPH_TYPES[type] || 'span'
    end
  end
end
