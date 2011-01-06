class String
  def levenshtein_distance(other_str)
    _self_str = self.downcase
    _othr_str = other_str.downcase
 
    return 0 if _self_str == _othr_str    
    return _self_str.length if (0 == _othr_str.length)
    return _othr_str.length if (0 == _self_str.length)
 
    unpack_rule = ($KCODE =~ /^U/i) ? 'U*' : 'C*'
 
    _str_1, _str_2 = if _self_str.length > _othr_str.length
      [_self_str, _othr_str]
    else
      [_othr_str, _self_str]
    end
 
    difference_counter = _str_1.length - _str_2.length
 
    _str_1 = _str_1[0, _str_2.length].unpack(unpack_rule)
    _str_2 = _str_2.unpack(unpack_rule)
 
    _str_1.each_with_index do |char1, idx|
      char2 = _str_2[idx]
      difference_counter += 1 if char1 != char2
    end
 
    return difference_counter
  end
end