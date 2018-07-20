class CreateJoinTableStaffAppointment < ActiveRecord::Migration[5.2]
  def change
    create_join_table :staffs, :appointments do |t|
      t.index [:staff_id, :appointment_id]
      # t.index [:appointment_id, :staff_id]
    end
  end
end
