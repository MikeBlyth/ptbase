class AdmissionsController < ApplicationController
  active_scaffold :admission do |config|
    config.list.columns = :patient, :date, :diagnosis_1, :diagnosis_2, :meds, :discharge_date, :discharge_status

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


  ############## FROM ORIGINAL APP #########################
  #  def list
  #    @edting = false
  #    @patient = Patient.find(params[:id])
  #    reckey = params[:id].to_i   # if not given, params[:reckey] is nil, and converts to integer 0
  #    @ptadm_pages, @ptadms = paginate (:ptadms, :per_page => 20, :order_by => 'adm_date DESC',
  #                                      :conditions => ["reckey = ?", reckey])
  #  end
  #
  #  def listall
  #    on_admission_filter = "disch_status = 'On Adm'"
  #    @summary = (params[:summary] == 'yes')
  #    if @summary
  #      per_page = 35
  #    else
  #      per_page = 20
  #    end
  #    @filter_on_adm = params.has_key?(:on_adm)
  #    filters = ['1 = 1']
  #    filters.push(on_admission_filter) if @filter_on_adm
  #    @edting = false
  #    if @filter_on_adm
  #      order = 'service, bed'
  #    else
  #      order = 'adm_date DESC'
  #    end
  #    @ptadm_pages, @ptadms = paginate :ptadms, :per_page => per_page, :order_by => order,
  #                                     :conditions => [filters.join(' and ')]
  #  end
  #
  #  def list_on_adm
  #    filters = ["disch_status = 'On Adm'"]
  #    order = 'service, bed'
  #    @ptadms = Ptadm.find(:all,
  #                         :order => order,
  #                         :conditions => [filters.join(' and ')] )
  #  end
  #
  #  def edit_on_adm
  #    filters = ["disch_status = 'On Adm'"]
  #    order = 'service, bed'
  #    @ptadms = Ptadm.find(:all,
  #                         :order => order,
  #                         :conditions => [filters.join(' and ')] )
  #  end
  #
  #  def update_on_adm
  #    adm_list = params[:adm]
  #    for id, adm in adm_list  # adm is now a single patient admission record to be updated, in form of hash of attributes. ID is the admission record number
  #      unless adm['discharged'] == "1"         # if patient has not been discharged, remove discharge attributes
  #        adm.delete('disch_date')
  #        adm.delete ('disch_status')
  #      end
  #      adm.delete('discharged')   # this attribute isn't part of the ptadm record, and update would choke on it
  #      adm_list[id] = adm   # update the incoming list of updates
  #    end
  ##		render (:inline => "<%= debug(@x)%><br><%=debug(@y) %>") and return
  #    Ptadm.update(adm_list.keys, adm_list.values)    # update each of the admission records to the new values from the submitted form
  #    redirect_to :action => 'list_on_adm'
  #  end
  #
  #  def list_date_range
  #    filters = ['1 = 1']
  #    filters.push('disch_date >= "2006-06-01"')
  #    filters.push('disch_date < "2006-07-01"')
  #    filters.push('service = "peds"')
  #    @edting = false
  #    @ptadm_pages, @ptadms = paginate :ptadms, :per_page => 20, :order_by => 'adm_date DESC',
  #                                     :order_by => 'icd9',
  #                                     :conditions => [filters.join(' and ')]
  #    render :action => 'listall'
  #  end
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
  #  def show
  #    @edting = false
  #    @ptadm = Ptadm.find(params[:id])
  #    @patient = @ptadm.patient
  #  end
  #
  #  def show_test
  #    @edting = false
  #    @ptadm = Ptadm.find(params[:id])
  #    @patient = @ptadm.patient
  #  end
  #
  #  def new
  #    @edting = true
  #    @ptadm = Ptadm.new
  #    @ptadm.adm_date = Time.now.strftime("%d-%b-%Y")
  #    @ptadm.reckey = params[:id].to_i
  #    @reckey = @ptadm.reckey
  #  end
  #
  #  def create
  #    @edting = false
  #    @ptadm = Ptadm.new(params[:ptadm])
  #    @ptadm.adm_date = my_date_parse(params[:ptadm][:adm_date])
  #    @ptadm.disch_date = my_date_parse(params[:ptadm][:disch_date])
  #    @ptadm.wt_disch = @ptadm.wt_adm     # use the admission weight as default discharge weight (also used for "current" wt while on admissions
  #    if @ptadm.save
  #      flash[:notice] = 'Ptadm was successfully created.'
  #      redirect_to :action => 'list', :id => @ptadm.patient
  #    else
  #      render :action => 'new'
  #    end
  #  end
  #
  #  def edit
  #    @edting = true
  #    @ptadm = Ptadm.find(params[:id])
  #  end
  #
  #  def update
  #    @edting = false
  #    @ptadm = Ptadm.find(params[:id])
  #    params[:ptadm][:adm_date] = my_date_parse(params[:ptadm][:adm_date])
  #    @params[:ptadm][:disch_date] = my_date_parse(params[:ptadm][:disch_date])
  #    if @ptadm.update_attributes(params[:ptadm])
  #      flash[:notice] = 'Ptadm was successfully updated.'
  #      redirect_to :action => 'show', :id => @ptadm
  #    else
  #      render :action => 'edit'
  #    end
  #  end
  #
  #  def destroy
  #    reckey = Ptadm.find(params[:id]).reckey
  #    Ptadm.find(params[:id]).destroy
  #    redirect_to :action => 'list', :id => reckey
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
  #
  #

end
