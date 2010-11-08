module ContactsHelper
  
  def can_destroy?(contact_org_units, user_org_units)
    intersection = contact_org_units & user_org_units
    result = !intersection.empty? && (intersection.size == contact_org_units.size)
    result
  end
  
end