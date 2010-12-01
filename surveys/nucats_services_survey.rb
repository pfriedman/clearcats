
survey "NUCATS Satisfaction Survey", :common_namespace => "clearcats", :common_identifier => "satisfaction_survey" do

  section "Service", :common_namespace => "clearcats", :common_identifier => "satisfaction_survey" do

    q "Please rate your satisfaction with the quality and content of this program on a scale of 1 to 5 with 1 (poor quality and content) and 5 (excellent quality and content).", :pick => :one, :display_type => :slider
    (1..5).to_a.each{ |num| a num.to_s }

    q "Please rate your satisfaction with the customer service provided by the NUCATS Institute personnel (faculty and staff) associated with this program. 1 (poor customer service) and 5 (excellent customer service).", :pick => :one, :display_type => :slider
    (1..5).to_a.each{ |num| a num.to_s }

    q "Please rate your interest in applying for another award or attending additional programs associated with the NUCATS Institute in the future. 1 (not interested at all) and 5 (very interested).", :pick => :one, :display_type => :slider
    (1..5).to_a.each{ |num| a num.to_s }
  
  end
  
end

