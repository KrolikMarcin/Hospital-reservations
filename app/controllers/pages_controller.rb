class PagesController < ApplicationController
  def home
    @specializations = User.clinic_specializations
  end
end
