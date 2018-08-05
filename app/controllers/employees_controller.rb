class EmployeesController < ApplicationController
  def index
    @employees = Employee.all
  end

  def new
    @employees = Employee.new
  end

  def create
    @employee = Employee.new(employees_params)
    if @employee.save
      redirect_to employee_path
    else
      render :new
    end
  end

  private

  def employees_params
    params.require(:employee).permit(
      :first_name, :last_name, :pesel, :specializaton
    )
  end
end
