require 'spec_helper'

describe ActivityCategory do
  it "should be invalid without name" do
    ActivityCategory.validate(:name).should have(1).errors_on(:name)
  end
  it "should be invalid without short_description" do
    ActivityCategory.validate(:short_description).should have(1).errors_on(:short_description)
  end
  it "should be invalid without front_photo_id" do
    ActivityCategory.validate(:front_photo_id).should have(1).errors_on(:front_photo_id)
  end
end
