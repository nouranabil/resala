require 'spec_helper'

describe Volunteer do
  it "should be invalid without name" do
    Volunteer.validate(:name).should have(1).errors_on(:name)
  end
  it "should be invalid without email" do
    Volunteer.validate(:email).should have(1).errors_on(:email)
  end
  it "should be invalid without date of birth" do
    Volunteer.validate(:date_of_birth).should have(1).errors_on(:date_of_birth)
  end
  it "should be invalid without gender" do
    Volunteer.validate(:gender).should have(1).errors_on(:gender)
  end
end
