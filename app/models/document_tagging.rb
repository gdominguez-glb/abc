class DocumentTagging < ActiveRecord::Base
  belongs_to :document
  belongs_to :tag, class_name: 'DocumentTag'
end
