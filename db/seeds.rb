# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

############ THESE ARE FOR TESTING ONLY ############
Diagnosis.delete_all
Diagnosis.create(name: 'pneumonia')
Diagnosis.create(name: 'malaria')

Drug.delete_all
Drug.create(name: 'amoxycillin', drug_class: 'antibiotic', drug_subclass: 'penicillin', synonyms: 'amoxacillin; amoxyl; amoxil')
Drug.create(name: 'artemether', drug_class: 'antimalarial', synonyms: 'Larither')
Patient.delete_all
anderson = Patient.create(last_name: 'Anderson', first_name: 'Charity', sex: 'F', birth_date: '1989-05-15', ident: 'P001')
audu = Patient.create(last_name: 'Audu', first_name: 'Mohammed', sex: 'M', birth_date: '2003-09-15', ident: 'P002')

User.delete_all
User.create(email: 'admin@example.com', password: 'appendix')

Visit.delete_all
audu.visits.create(patient_id: audu.id, date: '2011-07-30')
audu.visits.create(patient_id: audu.id, date: '2012-04-12')
