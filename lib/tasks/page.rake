namespace :page do
  desc "Add old in archived page slug"
  task add_old: :environment do
    Page.archived.each do |p|
      p.slug = p.slug + "-old-" + SecureRandom.hex(3)
      p.save
    end
  end

  desc "Remove old from unarchive page slug"
  task remove_old: :environment do
    Page.unarchive.each do |p|
      p.slug = p.slug.split(/-old-(?=[^-old-][0-9a-zA-Z_])/).try(:first)
      p.save
    end
  end
end
