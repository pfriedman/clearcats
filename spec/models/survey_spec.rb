require 'spec_helper'

describe Survey do

  it "should instantiate Survey" do
    Survey.new.should_not be_nil
  end

  it { should have_many(:sections) }

end