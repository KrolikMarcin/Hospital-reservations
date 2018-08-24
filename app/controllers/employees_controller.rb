class EmployeesController < ApplicationController
  def index
    @employees = Employee.all
  end

  def new
    @employee = Employee.new
    @employee.build_user
    @employee.user.build_address
  end

  def create
    employee = Employee.new(employees_params)
    employee.user = current_user
    if employee.save
      redirect_to employee_path(employee)
    else
      render :new
    end
  end

  private

  def employees_params
    params.require(:employee).permit(:first_name, :last_name, :pesel,
                                     :specializaton, user_attributes:
    [address_attributes: [:street, :house_number, :apartment_number,
                          :city, :postal_code]])
  end
end
