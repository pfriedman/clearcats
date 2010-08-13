class WelcomeController < ApplicationController
  permit :Admin, :User
  
  def index
  end
end