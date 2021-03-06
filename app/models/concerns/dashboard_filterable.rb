module DashboardFilterable
  extend ActiveSupport::Concern

  included do
    scope :filter_by_subject_or_user_title_or_zip_code, -> (subjects, user_title, zip_code) {
      filter_conds = []
      filter_conds << "(subject in (:subject))" if subjects.present?
      filter_conds << "(user_title = 'Global' or user_title like :user_title)" if user_title.present?
      filter_conds << "(zip_codes like :zip_code OR zip_codes = '')" if zip_code.present?

      if filter_conds.present?
        where(filter_conds.join(" and "), subject: subjects + ['Global'], user_title: "%#{user_title}%", zip_code: "%#{zip_code}%")
      else
        where('1=1')
      end
    }
  end
end
