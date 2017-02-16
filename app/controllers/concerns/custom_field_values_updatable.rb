module CustomFieldValuesUpdatable
  extend ActiveSupport::Concern

  def update_custom_field_values(user)
    return if params[:spree_user][:custom_field_values_attributes].nil?

    params[:spree_user][:custom_field_values_attributes].each do |attr|
      attr = sanatize_attr(attr)
      custom = CustomFieldValue.find_by(id: attr[:id])
      custom = CustomFieldValue.new if custom.nil?
      custom.assign_attributes(value: attr[:value], values: attr[:values], custom_field_id: attr[:custom_field_id], user_id: user.id)
      custom.save!
    end
  end

  def sanatize_attr(attr)
    attr = attr.last
    attr[:id] ||= nil
    attr[:value] ||= nil
    attr[:values] ||= nil
    attr
  end
end