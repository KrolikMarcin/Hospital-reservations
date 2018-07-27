class StaffsController < ApplicationController
  def index
    @staffs = Staff.all
  end
  
  def new
     @staff = Staff.new
  end

  def create
    @staff = Staff.new(staff_params)
    if @staff.save
      redirect_to staff_path(@staff)
    else
      render :new
    end
  end

  private
    def staff_params
      params.require(:staff).permit(:first_name, :last_name, :pesel, :specializaton)
end