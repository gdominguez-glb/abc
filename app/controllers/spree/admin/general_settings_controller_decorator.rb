Spree::Admin::GeneralSettingsController.class_eval do
  def sync_staging
    flash[:notice] = "Queued background job to sync production marketing pages to staging, please review in staging for few minutes."
    DataDumperWorker.perform_async
    redirect_back(fallback_location: '/')
  end
end
