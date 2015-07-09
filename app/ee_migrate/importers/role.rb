module Importers
  class Role
    def self.import
      Migrate::MemberGroup.find_each do |member_group|
        Spree::Role.find_or_create_by(name: member_group.group_title)
      end
    end
  end
end
