# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

############ THESE ARE FOR TESTING ONLY ############
Patient.delete_all
anderson = Patient.create(last_name: 'Anderson', first_name: 'Charity', sex: 'F', birth_date: '1989-05-15', ident: 'P001')
audu = Patient.create(last_name: 'Audu', first_name: 'Mohammed', sex: 'M', birth_date: '2003-09-15', ident: 'P002')

Admission.delete_all
Admission.create(patient: audu, date: audu.birth_date+12.months, diagnosis_1: 'malaria', meds: 'ampicillin')

Diagnosis.delete_all
Diagnosis.create(name: 'pneumonia')
Diagnosis.create(name: 'malaria')

Drug.delete_all
amox = Drug.create(name: 'amoxycillin', drug_class: 'antibiotic', drug_subclass: 'penicillin', synonyms: 'amoxacillin; amoxyl; amoxil')
Drug.create(name: 'artemether', drug_class: 'antimalarial', synonyms: 'Larither')

DrugPrep.delete_all
DrugPrep.create(drug_id: amox.id, xform: 'tablet', strength: '250 mg')
DrugPrep.create(drug_id: amox.id, xform: 'suspension', strength: '250 mg/5 ml', synonyms: 'liquid')

HealthData.delete_all
HealthData.create(patient: audu, hiv_status: 'P', maternal_hiv_status: 'P' )
HealthData.create(patient: anderson, hiv_status: '', maternal_hiv_status: '' )

Icd9.delete_all
Icd9.create(icd9: '011', description: 'pulmonary tuberculosis')
Icd9.create(icd9: '084', description: 'malaria')
Icd9.create(icd9: '042', description: 'HIV')

Immunization.delete_all
birth = audu.birth_date
Immunization.create(patient: audu, bcg: birth+2.weeks, opv1: birth+6.weeks, opv2: birth+10.weeks, dpt1: birth+6.weeks, dpt2: birth+10.weeks)

Lab.delete_all
Lab.create(patient: audu, date: audu.birth_date+5.months, hct: 34)

Photo.delete_all
Photo.create(patient: audu, date: audu.birth_date+5.months)

Provider.delete_all
hertz = Provider.create(last_name: 'Hertz', first_name: 'Joshua', ident: 'Prov 001')

Prescription.delete_all
prescription = Prescription.create(patient: audu, date: audu.birth_date+5.months, provider: hertz,
                                   confirmed: true)
recent_prescription = Prescription.create(patient: audu, date: Date.yesterday, provider: hertz,
                                   confirmed: true)

PrescriptionItem.delete_all
PrescriptionItem.create(prescription: prescription, drug: 'ampicillin', dose: '250 mg', unit: 'tab',
                        route: 'po', interval: 6, duration: 6)
PrescriptionItem.create(prescription: recent_prescription, drug: 'amoxacillin', dose: '500 mg', unit: 'tab',
                        route: 'po', interval: 8, duration: 6)

Problem.delete_all
Problem.create(patient: audu, date: '2010-01-01', description: 'malaria', resolved: '2010-01-05')

User.delete_all
User.create(email: 'admin@example.com', password: 'appendix', username: 'admin', name: 'Administrator')

Visit.delete_all
audu.visits.create(patient_id: audu.id, date: '2011-07-30', dx: 'pneumonia')
audu.visits.create(patient_id: audu.id, date: '2012-04-12', dx: 'malaria', dx2: 'gastroenteritis',
    weight: 30, meds: 'artequine')
