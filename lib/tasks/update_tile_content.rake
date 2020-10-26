# frozen_string_literal: true

namespace :update_tile_content do
  desc 'Update background color with associated font color'
  task background_and_font: :environment do
    # blue-bg, cream-bg, coral-bg, grey-bg
    @logger ||= Logger.new("#{Rails.root}/log/update_tile_content.log")
    @background_colors = %w[cream-bg blue-bg grey-bg coral-bg dark-orange-bg]
    @tiles_colors = %w[cream blue grey coral dark-orange]
    Page.find_each do |page|
      @logger.info("Page Id: #{page.id}")
      html        = page.body_draft
      parsed_data = Nokogiri::HTML.parse(html)
      changed_background_color(parsed_data)
      update_html(page, parsed_data)
      update_tiles(page)
      page.save
    end
  end

  def update_html(page, parsed_data)
    page.body_draft = parsed_data.to_html
    page.body = parsed_data.to_html
  end

  def update_tiles(page)
    rows = page.tiles[:rows]
    rows.each do |row|
      if @tiles_colors.include?(row[:background_color])
        row[:background_color] = 'white'
      end
    end
    page.tiles[:rows] = rows
  end

  # TODO: Change background color
  def changed_background_color(parsed_data)
    sections = parsed_data.css('section')
    sections.each do |section|
      color_classes = section.attributes['class'].value
      section.attributes['class'].value = convert_colors(color_classes)
    end
  end

  def convert_colors(color_classes)
    regex = /([cream|blue|grey|coral]*-bg)|(dark-orange-bg)/
    if color_available?(color_classes)
      color_classes.gsub(regex, 'white-bg')
    else
      color_classes
    end
  end

  def color_available?(color_classes)
    (color_classes.split & @background_colors).any?
  end
end
