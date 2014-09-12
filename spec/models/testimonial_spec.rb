require 'spec_helper'

describe Testimonial do
  it "should be invalid without title" do
    Testimonial.validate(:title).should have(1).errors_on(:title)
  end
  it "should be invalid without source" do
    Testimonial.validate(:source).should have(1).errors_on(:source)
  end
end
