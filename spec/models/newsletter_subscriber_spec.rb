require 'spec_helper'

describe NewsletterSubscriber do
  it "should be invalid without email" do
    NewsletterSubscriber.validate(:email).should have(1).errors_on(:email)
    NewsletterSubscriber.validate(:name).should have(1).errors_on(:name)
  end
end
