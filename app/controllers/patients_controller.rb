class PatientsController < ApplicationController
  
  def new
    
    @patient = Patient.new
    
    
    address = Address.new
    @patient.address = address
  end

end