namespace :grades do
  desc "Loading all default grades."
  task :load => :environment do
    if Spree::Grade.count == 0
      [
        { name: 'Kindergarten', abbr: 'K', school: 'Elementary School' },
        { name: 'Grade 1', abbr: '1', school: 'Elementary School' },
        { name: 'Grade 2', abbr: '2', school: 'Elementary School' },
        { name: 'Grade 3', abbr: '3', school: 'Elementary School' },
        { name: 'Grade 4', abbr: '4', school: 'Elementary School' },
        { name: 'Grade 5', abbr: '5', school: 'Elementary School' },
        { name: 'Grade 6', abbr: '6', school: 'Middle School' },
        { name: 'Grade 7', abbr: '7', school: 'Middle School' },
        { name: 'Grade 8', abbr: '8', school: 'Middle School' },
        { name: 'Grade 9', abbr: '9', school: 'High School' },
        { name: 'Grade 10', abbr: '10', school: 'High School' },
        { name: 'Grade 11', abbr: '11', school: 'High School' },
        { name: 'Grade 12', abbr: '12', school: 'High School' },
      ].each do |grade_hash|
        Spree::Grade.create!(grade_hash)
      end
    end
  end
end
