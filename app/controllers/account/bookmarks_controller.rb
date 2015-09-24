class Account::BookmarksController < Account::BaseController
  def index
    @bookmarks = current_spree_user.bookmarks.includes([:bookmarkable])
  end

  def destroy
    bookmark = current_spree_user.bookmarks.find(params[:id])
    bookmark.destroy
    redirect_to account_bookmarks_path
  end
end
