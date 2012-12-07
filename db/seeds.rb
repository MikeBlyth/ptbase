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
amox = Drug.create(name: 'amoxycillin', drug_class: 'antibiotic', drug_subclass: 'penicillin', synonyms: 'amoxacillin; amoxyl; amoxil')
Drug.create(name: 'artemether', drug_class: 'antimalarial', synonyms: 'Larither')

Patient.delete_all
anderson = Patient.create(last_name: 'Anderson', first_name: 'Charity', sex: 'F', birth_date: '1989-05-15', ident: 'P001')
audu = Patient.create(last_name: 'Audu', first_name: 'Mohammed', sex: 'M', birth_date: '2003-09-15', ident: 'P002')

DrugPrep.delete_all
DrugPrep.create(drug_id: amox.id, form: 'tablet', strength: '250 mg')
DrugPrep.create(drug_id: amox.id, form: 'suspension', strength: '250 mg/5 ml', synonyms: 'liquid')

HealthData.delete_all
HealthData.create(patient: audu, hiv_status: 'P', maternal_hiv_status: 'P' )
HealthData.create(patient: anderson, hiv_status: '', maternal_hiv_status: '' )

Immunization.delete_all
Immunization.create(patient: audu, date: audu.birth_date+1.week, hepb1: 'given')
Immunization.create(patient: audu, date: audu.birth_date+3.months, bcg: 'given', opv1: 'given', dpt2: 'given')
Immunization.create(patient: audu, date: audu.birth_date+5.months, opv2: 'given', dpt2: 'given')

Lab.delete_all
Lab.create(patient: audu, date: audu.birth_date+5.months, hct: 34)

Photo.delete_all
Photo.create(patient: audu, date: audu.birth_date+5.months)

Provider.delete_all
hertz = Provider.create(last_name: 'Hertz', first_name: 'Joshua', ident: 'Prov 001')

Prescription.delete_all
prescription = Prescription.create(patient: audu, date: audu.birth_date+5.months, prescriber: hertz,
            confirmed: true)

PrescriptionItem.delete_all
PrescriptionItem.create(prescription: prescription, drug: 'ampicillin', dose: '250 mg', units: 'tab', route: 'po', interval: 6, duration: 6)

User.delete_all
User.create(email: 'admin@example.com', password: 'appendix', username: 'admin', name: 'Administrator')

Visit.delete_all
audu.visits.create(patient_id: audu.id, date: '2011-07-30')
audu.visits.create(patient_id: audu.id, date: '2012-04-12')
