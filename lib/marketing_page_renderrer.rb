require 'erb'

class MarketingPageRenderrer

  MARKETING_TEMPLATES = YAML.load_file(Rails.root.join('config/marketing_page.yml'))['marketing_templates']

  def initialize(page)
    @page = page
  end

  def render
    rows = @page.tiles[:rows]
    rows = rows.sort_by{|r| r['position'].to_i }
    rows.map do |tile_row|
      render_tile_row(tile_row)
    end.join('')
  end

  def render_tile_row(tile_row)
    template = MARKETING_TEMPLATES.find{|t| t['name'] == tile_row['rowType'] }
    ERB.new(template['content']).result(generate_binding(tile_row))
  end

  def generate_binding(tile_row)
    blank_tile_rows = build_blank_tile_rows(tile_row)
    b = binding
    blank_tile_rows.merge(tile_row).each do |k, v|
      b.local_variable_set(k, v)
    end
    b
  end

  def build_blank_tile_rows(tile_row)
    tile_definition      = Page::TILES.find{|t| t[:name] == tile_row['rowType'] }
    all_tile_field_names = tile_definition[:fields].map{|f| f[:name]}
    Hash[all_tile_field_names.map{|n| [n, nil] }]
  end
end
