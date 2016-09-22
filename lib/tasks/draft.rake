namespace :draft do
  desc "Migrate data to draft"
  task migrate: :environment do
    Page.find_each do |page|
      page.update(body_draft: page.body)
    end
    Job.find_each do |job|
      job.update(content_draft: job.content)
    end
  end
end
