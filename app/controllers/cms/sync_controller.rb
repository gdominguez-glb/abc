class Cms::SyncController < Cms::BaseController
  def run
    DataSyncWorker.perform_async
    redirect_to cms_root_path, notice: 'Ran sync job in background now.'
  end
end
