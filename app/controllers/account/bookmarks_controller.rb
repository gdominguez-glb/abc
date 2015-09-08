class Account::BookmarksController < Account::BaseController
  def index
    @bookmarks = current_spree_user.bookmarks.includes([:bookmarkable])
  end

  def destroy
  end
end
