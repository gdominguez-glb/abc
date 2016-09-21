class DataSyncer::JobSyncer < DataSyncer::Base
  def generate_yaml_content(klass)
    Job.order(:position).map do |job|
      job.attributes
    end.to_yaml
  end
end
