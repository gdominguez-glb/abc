module DownloadPagesHelper
  def nested_materials(materials)
    return [] if materials.size == 0

    result_item = Struct.new(:material_id, :material, :children, :level)

    root           = result_item.new(nil, nil, [])
    path           = [nil]
    parents        = [root]

    materials.each_with_index do |o, i|
      item = result_item.new(o.id, o, [])

      if o.parent_id != path.last
        while path.last != o.parent_id
          path.pop
          parents.pop
        end
      end

      item.level = path.size

      parent = parents.last
      parent.children << item
      path << o.id
      parents << item
    end

    root.children
  end
end
