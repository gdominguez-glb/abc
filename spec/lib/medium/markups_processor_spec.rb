require 'rails_helper'
require 'medium'

RSpec.describe Medium::MarkupsProcessor do
  let(:link_opts) do
    {
      text: "An expert review of classroom math materials released Wednesday gives Eureka Math top marks. Eureka Math is written by teachers and mathematicians and published by the nonprofit Great Minds.",
      markups: [
        {"type"=>3, "start"=>178, "end"=>189, "href"=>"http://greatminds.net/", "title"=>"", "rel"=>"", "anchorType"=>0},
        {"type"=>2, "start"=>70, "end"=>81}, {"type"=>2, "start"=>93, "end"=>104}]
    }
  end

  it "process markups with links" do
    expect(Medium::MarkupsProcessor.new(link_opts).process).to eq("An expert review of classroom math materials released Wednesday gives <em>Eureka Math</em> top marks. <em>Eureka Math</em> is written by teachers and mathematicians and published by the nonprofit <a href='http://greatminds.net/' title='' rel=''>Great Minds</a>")
  end
end
