class CurriculumMail < ApplicationRecord
  validates_presence_of :subject, :content, :curriculum

  enum status: [:pending, :processing, :done]

  before_validation(on: :create) do
    self.status = :pending
  end

  after_create -> { CurriculumMailWorker.perform_async(self.id) }

  CURRICULUMS = ['Math', 'English', 'History']
end
