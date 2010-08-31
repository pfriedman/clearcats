module Surveyor
  module SurveyorControllerMethods
    def get_current_user
      person = Person.find_by_username(current_user.username)
      return person.nil? ? current_user : person
    end
  end
end