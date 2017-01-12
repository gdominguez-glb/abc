module WhatsnewRecommendationSharable
  extend ActiveSupport::Concern

  def sanatize_role_params(key)
    return '' if params[key][:user_title].blank?
    params[key][:user_title].reject! { |p| p.empty? }
    return params[key][:user_title] = 'Global' if params[key][:user_title].include? 'Global'
    params[key][:user_title] = params[key][:user_title].join(',')
  end
end