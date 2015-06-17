module Medium
  class ParagraphsProcessor
    def initialize(opts = {})
      @paragraphs = opts[:paragraphs]
    end

    def process
      @paragraphs.map do |paragraph|
        process_paragraph(paragraph)
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

    def paragraph_tag(type)
      PARAGRAPH_TYPES[type] || 'span'
    end
  end
end
