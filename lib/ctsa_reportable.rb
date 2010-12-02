module CtsaReportable

  REPORTING_YEARS = (2000..2025).to_a
  
  def ctsa_reporting_years=(yrs)
    self.ctsa_reporting_years_mask = (yrs & REPORTING_YEARS).map { |yr| 2**REPORTING_YEARS.index(yr) }.sum
  end  

  def ctsa_reporting_years
    REPORTING_YEARS.reject { |yr| ((ctsa_reporting_years_mask || 0) & 2**REPORTING_YEARS.index(yr)).zero? }  
  end
  
end