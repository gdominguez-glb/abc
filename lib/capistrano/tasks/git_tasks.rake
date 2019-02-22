namespace :git do
  desc 'Prune origin refs'
  task prune: :'git:clone'  do
    on roles(:all) do |host|
      within repo_path do
        with fetch(:git_environmental_variables) do
          execute :git, :remote, :prune, :origin
        end
      end
    end
  end
end
