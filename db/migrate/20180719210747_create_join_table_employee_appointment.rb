class CreateJoinTableEmployeeAppointment < ActiveRecord::Migration[5.2]
  def change
    create_join_table :employees, :appointments do |t|
      t.index [:employee_id, :appointment_id]
    end
  end
end
