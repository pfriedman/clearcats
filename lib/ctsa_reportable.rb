module CtsaReportable

  REPORTING_YEARS = (2000..2025).to_a
  
  def ctsa_reporting_years=(yrs)
    self.ctsa_reporting_years_mask = (yrs & REPORTING_YEARS).map { |yr| 2**REPORTING_YEARS.index(yr) }.sum
  end  

  def ctsa_reporting_years
    REPORTING_YEARS.reject { |yr| ((ctsa_reporting_years_mask || 0) & 2**REPORTING_YEARS.index(yr)).zero? }  
  end
  
  def ctsa_reportable
    ctsa_reporting_years.include?(current_year)
  end
  
  def ctsa_reportable=(val)
    yrs = ctsa_reporting_years
    yrs.delete(current_year)
    yrs << current_year if val.to_i > 0
    self.ctsa_reporting_years = yrs
  end

  private
  
    def current_year
      return (Date.today.month == 1) ? Date.today.year - 1 : Date.today.year
    end
  
end