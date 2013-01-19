class IndexVisitForHstore < ActiveRecord::Migration
  def up
    execute "CREATE INDEX visits_symptoms ON visits USING GIN(symptoms)"
    execute "CREATE INDEX visits_diagnoses ON visits USING GIN(diagnoses)"
    execute "CREATE INDEX visits_exam ON visits USING GIN(exam)"
  end

  def down
    execute "DROP INDEX visits_symptoms"
    execute "DROP INDEX visits_diagnoses"
    execute "DROP INDEX visits_exam"
  end
end
