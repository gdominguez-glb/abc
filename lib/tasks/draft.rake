namespace :draft do
  desc "Migrate data to draft"
  task migrate: :environment do
    Page.find_each do |page|
      page.update(body_draft: page.body)
    end
    Job.find_each do |job|
      job.update(content_draft: job.content)
    end
    EventPage.find_each do |event_page|
      event_page.update(description_draft: event_page.description)
    end
  end
end
