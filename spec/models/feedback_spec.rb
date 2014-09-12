require 'spec_helper'

describe Feedback do
  it "should be invalid without email" do
    Feedback.validate(:email).should have(1).errors_on(:email)
    Feedback.validate(:title).should have(1).errors_on(:title)
    Feedback.validate(:body).should have(1).errors_on(:body)
  end
end
