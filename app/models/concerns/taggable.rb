module Taggable
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_attribute :tag_klass
    base.class_attribute :tagging_klass
  end

  class_methods do

    def activate_taggble(_tag_klass, _tagging_klass)

      class_eval do
        self.tag_klass = _tag_klass
        self.tagging_klass = _tagging_klass

        has_many :taggings, class_name: tagging_klass.name
        has_many :tags, class_name: tag_klass.name, through: :taggings

        scope :tagged_with, ->(tag_list) {
          joins(:tags).
          where(_tag_klass.table_name => { name: tag_list.split(',') })
        }
      end
    end

  end

  def tag_list=(names)
    self.tags = names.split(",").map do |name|
      tag_klass.where(name: name.strip).first_or_create!
    end
  end

  def tag_list
    self.tags.map(&:name).join(", ")
  end

end
