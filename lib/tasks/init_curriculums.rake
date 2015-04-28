namespace :curriculums do
  desc "Loading all default grades."
  task :load => :environment do
    if Spree::Curriculum.count == 0
      [
        { name: 'Math', slug: 'math' },
        { name: 'English', slug: 'english' },
        { name: 'History', slug: 'history' }
      ].each_with_index do |curriculum_hash, index|
        Spree::Curriculum.create!(curriculum_hash.merge(position: index))
      end
    end
  end
end
