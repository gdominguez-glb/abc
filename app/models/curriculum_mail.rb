class CurriculumMail < ActiveRecord::Base
  validates_presence_of :subject, :content, :curriculum

  enum status: [:pending, :processing, :done]

  before_validation(on: :create) do
    self.status = :pending
  end

  CURRICULUMS = ['Math', 'English', 'History']
end
