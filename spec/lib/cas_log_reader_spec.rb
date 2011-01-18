require 'spec_helper'

describe CasLogReader do

  it "should extract all unique usernames who attempted to login" do
    
    logfilepath = File.expand_path(File.dirname(__FILE__) + '/../data/cas.log')
    usernames = CasLogReader.extract_usernames(logfilepath)
    usernames.size.should == 4
    usernames.should include("skk958")
    usernames.should include("amo563")
    usernames.should include("jhe722")
    usernames.should include("ssa262")
  end

end