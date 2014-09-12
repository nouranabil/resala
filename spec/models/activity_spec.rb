require 'spec_helper'

describe Activity do
  it "should be invalid without title" do
    Activity.validate(:title).should have(1).errors_on(:title)
  end
  it "should be invalid without description" do
    Activity.validate(:description).should have(1).errors_on(:description)
  end
  it "should be invalid without activity_categories" do
    Activity.validate(:activity_categories).should have(1).errors_on(:activity_categories)
  end
end