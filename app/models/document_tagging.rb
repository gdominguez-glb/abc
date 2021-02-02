class DocumentTagging < ApplicationRecord
  belongs_to :document
  belongs_to :tag, class_name: 'DocumentTag'
end
