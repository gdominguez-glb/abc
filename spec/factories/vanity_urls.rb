FactoryBot.define do
  factory :vanity_url do
    url { "http://test.foo/abc" }
    redirect_url { "http://test.foo/a/c" }
  end

end
