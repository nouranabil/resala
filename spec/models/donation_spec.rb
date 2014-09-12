require 'spec_helper'

describe Donation do
  it "should be invalid without amount" do
    Donation.validate(:amount).should have(1).errors_on(:amount)
  end
end
