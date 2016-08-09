class DataSyncer::AnswerSyncer < DataSyncer::Base
  def generate_yaml_content(klass)
    Answer.all.map do |answer|
      attrs = answer.attributes
      attrs['content'] = convert_urls_in_content(answer['content']) if answer['content'].present?
      attrs
    end.to_yaml
  end
end
