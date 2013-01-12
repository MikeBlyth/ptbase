class ChangeLabRequestCols < ActiveRecord::Migration
  def change
    drop_table :lab_requests
    create_table :lab_requests do |t|
      t.remove :hct
      t.remove :fbc
      t.remove :malaria
      t.remove :hiv_rapid
      t.remove :urinalysis
      t.remove :blood_glucose
      t.remove :cd4
      t.remove :patient_id
      t.integer :request_id
      t.integer :provider_id
    end
  end

end
