require 'spec_helper'

describe User do

  it { should belong_to(:organizational_unit) }

  it { should validate_presence_of(:username) }

end
