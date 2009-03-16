require File.dirname(__FILE__) + '/../spec_helper'

describe GoogleSearch do
  before(:each) do
    @google_search = GoogleSearch.new
  end

  it "should be valid" do
    @google_search.should be_valid
  end
end
