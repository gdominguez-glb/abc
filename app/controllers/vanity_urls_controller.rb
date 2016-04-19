class VanityUrlsController < ApplicationController
  def show
    @vanity_url = VanityUrl.find_by(url: request.original_url)
    redirect_to @vanity_url.redirect_url
  end
end
