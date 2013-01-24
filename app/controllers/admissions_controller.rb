class AdmissionsController < ApplicationController

  active_scaffold :admission do |config|
    config.list.columns = :patient, :date, :diagnosis_1, :diagnosis_2, :meds, :discharge_date, :discharge_status
    config.columns[:discharge_date].inplace_edit = true
    config.columns[:discharge_status].inplace_edit = true
    config.columns[:discharge_status].options[:options] = Admission::DISCHARGE_STATUSES
    config.columns[:discharge_status].form_ui = :select
    as_no_inline = lambda do |action|
      config.send(action).link.page = true
      config.send(action).link.inline = false
    end
    %w(create update show).each &as_no_inline
  end

  def new
    @patient = Patient.find params[:patient_id]
    @admission = @patient.admissions.new
  end

  def edit
    @admission = Admission.find params[:id]
    @patient = Patient.find @admission.patient_id
  end

  def create
    @admission = Admission.new(params[:admission])
    if @admission.save
      flash[:notice] = 'admission was successfully created.'
      redirect_to :action => 'show', :id => @admission
    else
      @patient = Patient.find @admission.patient_id
      render :action => 'edit'
    end
  end

  def update
    @admission = admission.find(params[:id])
    if @admission.update_attributes(params[:admission])
      flash[:notice] = 'admission was successfully updated.'
      redirect_to :action => 'show', :id => @admission
    else
      render :action => 'edit'
    end
  end

  def conditions_for_collection
    params[:current] ? ["discharge_date IS ?", nil] : nil
  end

end
  ############## FROM ORIGINAL APP #########################
  #
  #  def report
  #    @start_date = Date.parse(params[:from_date])
  #    @end_date = Date.parse(params[:to_date])
  #    filters = ['1 = 1']
  #    filters.push('disch_date >= "' + params[:from_date] + '"')
  #    filters.push('disch_date < "' + params[:to_date]+ '"')
  #    filters.push('service = "peds"')
  #
  ##    @x = filters; render (:inline => "<%= debug(@x) %>") and return false
  #    @edting = false
  #    @ptadms = Ptadm.find(:all,
  #                         :conditions => [filters.join(' and ')])
  ## Table of diagnoses
  #    @diagnoses = {}
  #    @summaries = {}
  #    @ptadms.each do | adm |
  #      # Take the first icd9 code or, if none, make a '?'
  #      if adm.icd9.blank? || adm.icd9.nil?
  #        icd = '?'
  #      else
  #        icd = adm.icd9.split(/[; ]+/)[0]
  #      end
  #      @diagnoses.inc(icd)
  #      update_counts(icd, adm)       # Update counts for this icd diagnosis and...
  #      update_counts('999.99', adm)  #    for the Totals entry
  #    end
  ##    render (:inline => "<%= debug(@summaries) %>") and return false
  #    @diagnoses = @diagnoses.sort {|a, b| b[1] <=> a[1]}
  ## sort by number of admissions in each icd category
  #    @summaries = @summaries.sort {|a, b| b[1][:count] <=> a[1][:count]}
  #    @summaries.push @summaries.shift    # move first entry ("Totals") to end
  ##    render (:inline => "<%= debug(@summaries) %>") and return false
  ## Attach description to each ICD9 code. @diagnoses is now an array of [icd, count] arrays sorted by count.
  #    @diagnoses.each do | dx |
  #      icd9_rec = Icd9Code.find(:first, :conditions => ["icd9 = ?",dx[0]])
  #      if icd9_rec.nil?
  #        dx.push "No ICD9 code found for #{dx[0]}"
  #      else  # use short or long description, with preference to short. The long one is ~official
  #        if icd9_rec.short_desc
  #          dx.push icd9_rec.short_desc
  #        else
  #          dx.push icd9_rec.desc
  #        end
  #      end
  #    end
  #  end
  #
  #  def update_counts(icd, adm)
  #    pt = adm.patient
  #    # 1. Insert new icd9 code if this is the first time it has been found
  #    if ! @summaries.has_key?(icd)
  #      @summaries[icd] = {:count => 0, :males => 0, :females => 0, :deaths => 0,
  #                         :hiv => 0, :duration => 0}
  #      icd9_rec = Icd9Code.find(:first, :conditions => ["icd9 = ?", icd])
  #      if icd9_rec.nil?
  #        @x = "No ICD9 record for "+ icd
  #        #  render (:inline => @x) and return false
  #      elsif icd9_rec.short_desc || ''  > ''
  #        @summaries[icd][:desc] = icd9_rec.short_desc
  #      else
  #        @summaries[icd][:desc] = icd9_rec.desc
  #      end
  #    end
  #    # 2. Increment the appropriate counters for this patient/admission
  #    @summaries[icd][:count] = @summaries[icd][:count] + 1
  #    @summaries[icd][:males] = @summaries[icd][:males] + 1 if pt.sex == 'M'
  #    @summaries[icd][:females] = @summaries[icd][:females] + 1 if pt.sex == 'F'
  #    @summaries[icd][:deaths] = @summaries[icd][:deaths] + 1 if adm.disch_status.upcase == 'DIED'
  #    @summaries[icd][:hiv] = @summaries[icd][:hiv] + 1 if pt.hiv?
  #    duration = adm.disch_date - adm.adm_date
  #    @summaries[icd][:duration] = @summaries[icd][:duration] + duration if duration < 100 # arbitrary cutoff to avoid bad data
  #  end


