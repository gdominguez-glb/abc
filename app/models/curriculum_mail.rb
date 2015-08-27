class CurriculumMail < ActiveRecord::Base
  validates_presence_of :subject, :content, :curriculum

  enum status: [:pending, :processing, :done]

  before_validation(on: :create) do
    self.status = :pending
  end

  after_create -> { CurriculumMailer.notify(self.id).deliver_later }

  CURRICULUMS = ['Math', 'English', 'History']
end
