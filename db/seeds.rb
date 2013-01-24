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
audu = Patient.create(last_name: 'Audu', first_name: 'Mohammed', sex: 'M', birth_date: '2003-09-15',
                      ident: 'P002',
                      hiv_status: 'P', maternal_hiv_status: 'P')

Admission.delete_all
Admission.create(patient: audu, date: audu.birth_date+12.months, diagnosis_1: 'malaria', meds: 'ampicillin')

Diagnosis.delete_all
%w(pneumonia malaria HIV pulmonary_tb uri acute_ge otitis_media_acute otitis_media_chronic thrush
  tinea_capitis scabies parotitis).each {|x| Diagnosis.create(name: x, show_visits: true)}

Physical.delete_all
%w(head eyes ears mouth nose neck chest heart abdomen genitalia extremities
   neurologic back skin ).each {|x| Physical.create(name: x, show_visits: true)}

Symptom.delete_all
%w(wt_loss headache fever diarrhea numbness nausea rash vomiting cough night_sweats
   visual_prob_new pain_swallowing short_breath ).each {|x| Symptom.create(name: x, show_visits: true)}

Drug.delete_all
amox = Drug.create(name: 'amoxycillin', drug_class: 'antibiotic', drug_subclass: 'penicillin', synonyms: 'amoxacillin; amoxyl; amoxil')
Drug.create(name: 'artemether', drug_class: 'antimalarial', synonyms: 'Larither')

DrugPrep.delete_all
DrugPrep.create(drug_id: amox.id, xform: 'tablet', strength: '250 mg')
DrugPrep.create(drug_id: amox.id, xform: 'suspension', strength: '250 mg/5 ml', synonyms: 'liquid')

Icd9.delete_all
Icd9.create(icd9: '011', description: 'pulmonary tuberculosis')
Icd9.create(icd9: '084', description: 'malaria')
Icd9.create(icd9: '042', description: 'HIV')

Immunization.delete_all
birth = audu.birth_date
Immunization.create(patient: audu, bcg: birth+2.weeks, opv1: birth+6.weeks, opv2: birth+10.weeks, dpt1: birth+6.weeks, dpt2: birth+10.weeks)

LabGroup.delete_all
heme = LabGroup.create(name: 'Hematology', abbrev: 'heme')
ser_chem = LabGroup.create(name: 'Serum Chemistry', abbrev: 'ser-chem')
csf_chem = LabGroup.create(name: 'CSF chem', abbrev: 'csf-chem')
ur_chem = LabGroup.create(name: 'Urine Chemistry', abbrev: 'ur-chem')
serology = LabGroup.create(name: 'Serology', abbrev: 'serology')
bact = LabGroup.create(name: 'Bacteriology', abbrev: 'bact')
vir = LabGroup.create(name: 'Virology', abbrev: 'viro')

LabService.delete_all
hct = LabService.create(name: 'Hematocrit', abbrev: 'hct', cost: 700, lab_group: heme)
LabService.create(name: 'Blood white cell count', abbrev: 'wbc', cost: 700, lab_group: heme)
LabService.create(name: 'Blood neutrophil count', abbrev: 'neut', cost: 700, lab_group: heme)
LabService.create(name: 'Blood lymphocyte count', abbrev: 'lymph', cost: 700, lab_group: heme)
LabService.create(name: 'Blood band cell count', abbrev: 'bands', cost: 700, lab_group: heme)
LabService.create(name: 'Platelet count', abbrev: 'plat', cost: 700, lab_group: heme)
LabService.create(name: 'Malaria smear', abbrev: 'MPS', cost: 700, lab_group: heme)
cd4 = LabService.create(name: 'CD4 count', abbrev: 'CD4', cost: 700, lab_group: heme)
cd4pct = LabService.create(name: 'CD4 percent', abbrev: 'CD4%', cost: 700, lab_group: heme)

LabService.create(name: 'Urinalysis', abbrev: 'UA', cost: 700, lab_group: ser_chem)
LabService.create(name: 'Sodium, serum', abbrev: 'Na+', cost: 700, lab_group: ser_chem)
LabService.create(name: 'Potassium, serum', abbrev: 'K+', cost: 700, lab_group: ser_chem)
LabService.create(name: 'Calcium, serum', abbrev: 'Ca+', cost: 700, lab_group: ser_chem)
LabService.create(name: 'Bicarbonate, serum', abbrev: 'Bicarb', cost: 700, lab_group: ser_chem)

LabRequest.delete_all
audu_lab_1 = LabRequest.create(patient: audu)
audu_lab_1.created_at = audu.birth_date+5.months
audu_lab_1.save
audu_lab_2 = LabRequest.create(patient: audu)
audu_lab_1.created_at = Date.today - 1.year
audu_lab_1.save

LabResult.delete_all
LabResult.create(patient: audu, lab_request: audu_lab_1, lab_service: cd4, result: '1500')
LabResult.create(patient: audu, lab_request: audu_lab_1, lab_service: hct, result: '35')
LabResult.create(patient: audu, lab_request: audu_lab_2, lab_service: cd4, result: '450')
LabResult.create(patient: audu, lab_request: audu_lab_2, lab_service: hct, result: '28')

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

