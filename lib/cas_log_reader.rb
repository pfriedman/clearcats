class CasLogReader
  
  def self.extract_usernames(logfilepath)
    regexp = Regexp.new("Logging in with username: (.+), lt:")
    usernames = []
    f = File.open(logfilepath, "r") 
    f.each_line do |line|
      if matches = regexp.match(line)
        usernames << matches[1].strip
      end
    end
    return usernames
  end
  
end