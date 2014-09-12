require 'spec_helper'

describe DonationRequest do
  it "should be invalid without title" do
    DonationRequest.validate(:name).should have(1).errors_on(:name)
  end
  it "should be invalid without address" do
    DonationRequest.validate(:address).should have(1).errors_on(:address)
  end
end
