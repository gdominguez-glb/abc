namespace :draft do
  desc "Migrate data to draft"
  task migrate: :environment do
    Page.find_each do |page|
      page.update(body_draft: page.body)
    end
    Page.update_all(publish_status: 1, draft_status: 2)
    Job.update_all(publish_status: 1, draft_status: 2)
    Job.find_each do |job|
      job.update(content_draft: job.content)
    end
    EventPage.update_all(publish_status: 1, draft_status: 2)
    EventPage.find_each do |event_page|
      event_page.update(description_draft: event_page.description)
    end
    Question.update_all(publish_status: 1, draft_status: 2)
    Answer.find_each do |answer|
      answer.update(content_draft: answer.content)
    end
  end
end
