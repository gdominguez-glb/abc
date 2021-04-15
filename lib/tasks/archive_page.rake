# frozen_string_literal: true

namespace :archive_page do
  desc 'Archive these state-specific Eureka Math pages'
  task update_archive_field: :environment do
    state_specific_pages = ['massachusetts-0', 'tennessee-0', 'michigan-0',
                            'georgia', 'math/texas-1', 'nevada', 'kansas-0',
                            'arizona', 'washington', 'math/ohio',
                            'pennsylvania-0', 'math/idaho', 'oregon-0',
                            'colorado-0', 'nebraska-0', 'north-carolina-0']
    Page.where(slug: state_specific_pages).update_all(archived: true)
  end
end
