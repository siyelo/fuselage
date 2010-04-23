
Then /^I am redirected to "([^\"]*)"$/ do |url|
  assert [301, 302].include?(@integration_session.status), "Expected status to be 301 or 302, got #{@integration_session.status}"
  location = @integration_session.headers["Location"]
  assert_equal url, location
  visit location
end

Then /^I am not redirected to "([^\"]*)"$/ do |url|
  assert ![301, 302].include?(@integration_session.status), "Expected status to be 301 or 302, got #{@integration_session.status}"
  location = @integration_session.headers["Location"]
  assert_not_equal url, location
end


Then /^I am redirected to the sign in page for privileged access$/ do
  Then 'I am redirected to "/users/sign_in?unauthenticated=true"'
end

