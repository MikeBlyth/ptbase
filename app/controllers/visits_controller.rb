require 'pry'
class VisitsController < ApplicationController
  before_filter :authenticate_user!

  active_scaffold :visit do |config|
    config.columns = :patient, :date,:weight, :dx, :dx2, :meds, :adm
    config.list.columns = :patient, :date,:weight, :dx, :dx2, :meds, :adm
  end

  def do_edit
    patient = Patient.find params[:patient_id]
    set_diagnosis_fields
    @current_drugs = patient.current_drugs_formatted
    super
  end

  def do_new
    patient = Patient.find params[:patient_id]
    set_diagnosis_fields
    @current_drugs = patient.current_drugs_formatted
    super
  end

  def set_diagnosis_fields
    @dx_fields = Diagnosis.where(:show_visits => true).order('name ASC')
    @dx_fields.each { |dx| dx.name = 'dx_' + dx.name }   # prepend 'dx_' to each field name
  end


  ########### FROM ORIGINAL APP #########################
#  helper :sparklines
#  observer :growthchart_observer
#  layout 'default'
#  before_filter :authorize_as_admin, :only => :destroy
#
## ARV and Anti-TB Status Codes
## 0 (zero) = not on
## P = preparing, planning
## B = begin
## C = continue
## X = Stop
## V = change
#
#
#  def index
#    @editing = false
#    listall
#    render :action => 'listall'
#  end
#
#
#
#  def list
#    @editing = false
## if hospital number, not id, given, look up the id (specific to this database) and use that
#    if params.has_key?(:hosp_num)
#      @patient = Patient.find_by_hosp_num(params[:hosp_num])
#      params[:id] = @patient.id unless @patient.nil?
#    end
#    reckey = params[:id].to_i   # if not given, params[:reckey] is nil, and converts to integer 0
#    @patient = Patient.find(params[:id])
#    if reckey == 0
#      listall
#      render :action => 'listall'
#    else
#      begin
##            @patient = Patient.find(:reckey)
##            render(:inline => 'here') and return
##            render(:inline => debug(@patient)) and return
#        @ptvisit_pages, @ptvisits = paginate(:ptvisits, :per_page => 20, :order_by => 'date DESC',
#                                             :conditions => ["reckey = ?", reckey])
#      rescue
#        flash[:notice] = "Patient #{reckey} not found"
#        redirect_to (:controller => 'admin', :action => 'list', :params => {}) and return
#      end
#    end
#    if params[:detailed]=='y'
#      render :action => 'list_detailed'
#    end
#  end
#
#  def listall
#    @editing = false
#    @ptvisit_pages, @ptvisits = paginate(:ptvisits, :per_page => 20, :order => 'date DESC')
#  end
#
#  def show_last  # show most recent visit of patient :id
#    @editing = false
#    @patient = Patient.find(params[:id])
#    @ptvisit = @patient.ptvisits.find(:first, :order => 'date DESC')
#    if @ptvisit
#      redirect_to :action => 'show', :id => @ptvisit
#    else
#      flash[:notice] = 'No visits yet for this patient'
#      redirect_to :action => :list, :id => @patient
#    end
#  end
#
#  def show
#    @editing = false
#    @ptvisit = Ptvisit.find(params[:id])
#    @current_drugs = @ptvisit.patient.current_drugs_formatted
#    @patient = @ptvisit.patient
##    render(:inline => "<%= debug(@ptvisit) %>") and return
#
#  end
#
#  def pepfar_fu
#    @ptvisit = Ptvisit.find(params[:id])
#    if @ptvisit.next_visit.nil?		# get rounded estimate of weeks to next visit
#      @weeks_to_next = -1
#    else
#      @weeks_to_next = ((@ptvisit.next_visit - @ptvisit.date)/7.to_f).round
#    end
#    render(:layout => 'layouts/pepfar_form')
#  end
#
#  def new
#    set_diagnosis_fields()     # set up which diagnoses fields (checkboxes) will be shown on visit form
#    @ptvisit = Ptvisit.new
#    @ptvisit.reckey = params[:id].to_i
#    @ptvisit.date = Time.now.strftime("%d-%b-%Y")
#    @ptvisit.next_visit = "0000-00-00"
#    @patient = @ptvisit.patient
#    @ptvisit.arv_regimen = @ptvisit.arv_regimen_new = @patient.current_arv_regimen
#    @ptvisit.next_visit = 4.weeks.from_now if @ptvisit.patient.hiv_pos # default next appoint in 4 weeks
#    @ptvisit.arv_status = ''
#    @ptvisit.arv_status = 'O' unless @patient.hiv?
#    @ptvisit.anti_tb_status = ''
#    @current_drugs = @ptvisit.patient.current_drugs_formatted
#    @editing = true
#  end
#
#  def create
#    @editing = false
#    date = my_date_parse(params[:ptvisit][:date])  #*
#                                                   # Change 26-Jan-07: Check for existing visit for this date. If it exists, edit it instead of creating a new one.
#                                                   # If we ever need to allow multiple visits for a given date (e.g., in different clinics), then we'll
#                                                   # have to have a way around this, probably by searching for same "clinic" as well as same date.
#    @patient = Patient.find(params[:ptvisit][:reckey])
#    @ptvisit = @patient.ptvisits.find(:first,
#                                      :conditions => ['date = ?', date],
#                                      :order => 'id DESC')  #*
#    if ! @ptvisit.nil?
#      flash[:notice] = "There is an existing visit record (now shown): please edit it instead of creating new one."
#      redirect_to (:action => 'edit', :id => @ptvisit) and return
#    end
#    @ptvisit = Ptvisit.new(params[:ptvisit])
#    @ptvisit.date = date
#    @ptvisit.next_visit = my_date_parse(params[:ptvisit][:next_visit])  #*
#                                                   #    render (:inline, @ptvisit.next_visit.to_s) and return
#    if @ptvisit.save
#      flash[:notice] = 'Ptvisit was successfully created.'
#      redirect_to :action => 'show', :id => @ptvisit
#    else
##      render(:inline => "<%= @ptvisit.date %><br><%= DateTime.new %>") and return
#      @current_drugs = @ptvisit.patient.current_drugs_formatted
#      @patient = @ptvisit.patient
#      set_diagnosis_fields()
#      render :action => 'new'
#    end
#  end
#
#  def edit
#    set_diagnosis_fields()     # set up which diagnoses fields (checkboxes) will be shown on visit form
#    @ptvisit = Ptvisit.find(params[:id])
#    @patient = @ptvisit.patient
#    @editing = true
#    @current_drugs = @ptvisit.patient.current_drugs_formatted
#  end
#
#  def edit_test
#    set_diagnosis_fields()     # set up which diagnoses fields (checkboxes) will be shown on visit form
#    @ptvisit = Ptvisit.find(params[:id])
#    @editing = true
#  end
#
#  def update
#    @editing = false
#    @ptvisit = Ptvisit.find(params[:id])
#    ## The calendar program doesn't support a nested name like ptvisit[date], so trap unnested ones returned by form.
#    params[:ptvisit][:date] = my_date_parse(params[:ptvisit][:date]).to_s
#    params[:ptvisit][:next_visit] = my_date_parse(params[:ptvisit][:next_visit]).to_s
#    #    render(:inline => "<%= debug(params[:ptvisit][:date].class)%> ") and return false
#    if @ptvisit.update_attributes(params[:ptvisit])
#      flash[:notice] = 'Ptvisit was successfully updated.'
#      redirect_to :action => 'show', :id => @ptvisit
#    else
##      render(:inline => "<%= debug(@ptvisit) %>") and return false
#      set_diagnosis_fields()     # set up which diagnoses fields (checkboxes) will be shown on visit form
#      @patient = @ptvisit.patient
#      @current_drugs = @ptvisit.patient.current_drugs_formatted
#                                 # Kludge to get around issue of difficulty validating dates. Not good to have to do this for
#                                 # every date field, so it's something to work on.
#      @ptvisit.date = '' if @ptvisit.date == UNKNOWNDATE
#      @ptvisit.next_visit = '' if @ptvisit.next_visit == UNKNOWNDATE
#      render :action => 'edit', :id => @ptvisit
#    end
#  end
#
#  def destroy
#    Ptvisit.find(params[:id]).destroy
#    redirect_to :action => 'list'
#  end
#
#  def prescribe
#    @editing = false
#    render(:inline => "#{debug(params)}") and return
#  end
#
#  def destroy
#    reckey = Ptvisit.find(params[:id]).reckey
#    Ptvisit.find(params[:id]).destroy
#    redirect_to :action => 'list', :id => reckey
#  end
#
#  def set_diagnosis_fields
#    @dx_fields = Diagnosis.find(:all, :conditions => 'show_visits = 1',  :order => 'sort_order, name')
#    @dx_fields.each { |dx| dx.name = 'dx_' + dx.name }   # prepend 'dx_' to each field name
#  end
#
#  def set_first_visit
#    # Set/clear the "firstvisit" flag in each visit record.
#    #   (Set if it's the first visit in the database for that patient.)
#    @visits = Ptvisit.find(:all, :conditions => '1 = 1', :order => 'reckey, date')
#    prev_reckey = nil    # hold the id field (reckey) for previous visit in list to compare with current visit.
#                         # If different, then the current visit must be the first one for this patient
#
#    @updated_recs = 0
#    for v in @visits do
#      saveit = false   # clear flag for having to save this record
#                       # [boolean true/false doesn't compare well with MySQL 0/1, so use 0/1 in this comparison]
#      this_is_first_visit = 0
#      this_is_first_visit = 1 if (v.reckey != prev_reckey) # it's a first visit if this is different reckey
#      if v.firstvisit != this_is_first_visit    # update the firstvisit flag for record if it's not correct
#        v.firstvisit = this_is_first_visit
#        saveit = true
#      end
#                       # some old records have "0" instead of nil for sbp, dbp, or resp_rate. Fix these.
#      saveit = saveit || (v.sbp == 0) || (v.dbp == 0) || (v.resp_rate == 0) || (v.ht == 0) || (v.weight == 0)
#      v.sbp = nil if v.sbp == 0
#      v.dbp = nil if v.dbp == 0
#      v.resp_rate = nil if v.resp_rate == 0
#      v.ht = nil if v.ht == 0
#      v.weight = nil if v.weight == 0
#                       # save records that have changed
#      if saveit
#        v.save
#        @updated_recs = @updated_recs + 1
#      end
#      prev_reckey = v.reckey
##    render (:inline => "<%= debug(@updated_recs) %>") and return false
#    end
#    return
#  end
#
#  def appointments
## Show all appointments for a given date range
## So far, there is no separation of appointments for one clinic or another. If the program
## becomes used for more than PEPFAR, then we'll have to add this distinction.
## Set date range
#    if params[:from_date].blank?
#      @start_date = Date.today
#    else
#      @start_date = my_date_parse(params[:from_date])
#    end
#    if params[:to_date].blank?
#      @end_date = @start_date + 7  # Default period is one week
#    else
#      @end_date = my_date_parse(params[:to_date])
#    end
#    @start_date = @start_date.to_s
#    @end_date = @end_date.to_s
#    # Set conditions to look only for patients who have appointments in the required period,
#    #   who are alive, and
#    #   whose pepfar_status is either blank (null) or 'active' ('a')
#    conditions = 'next_visit >= ? AND next_visit <= ? ' +
#        ' AND NOT pt.died ' +
#        '  AND (ISNULL(pt.pepfar_status) OR pt.pepfar_status = "a") '
#    @appointments = Ptvisit.find(:all,
#                                 :joins => 'as visit inner join patients as pt on visit.reckey = pt.id',
#                                 :conditions => [conditions, @start_date, @end_date],
#                                 :order => 'next_visit')
#  end
#
#  def pepfar_report
##      render(:inline => "<%= debug(params) %>") and return
#    x = set_first_visit
#    filters = ['1 = 1']
#    # Set date range
#    # Convert from free string format to a DateTime object
#    start_date_str = params[:from_date]
#    end_date_str = params[:to_date]
#    @start_date = DateTime.parse(start_date_str,comp=true)
#    @end_date = DateTime.parse(end_date_str,comp=true)
#    # Convert back to a string but in the SQL format ('2006-12-25')
#    start_date_str = @start_date.strftime('%Y-%m-%d')
#    end_date_str = @end_date.strftime('%Y-%m-%d')
#    filters.push("date >= '#{start_date_str}'")
#    filters.push("date <= '#{end_date_str}'")
#    filters.push('patients.pepfar > 0')
#    @editing = false
#    @ptvisits = Ptvisit.find_by_sql("select ptvisits.*, pepfar, hosp_ident, CONCAT(last_name, ', ', other_names) as name FROM ptvisits " +
#                                        "LEFT JOIN patients ON ptvisits.reckey = patients.id " +
#                                        'WHERE ' + filters.join(' and ') +
#                                        ' ORDER BY last_name, other_names')
#    @arv_status = Bincounter.new;
#    @anti_tb_status = Bincounter.new;
#    @patient_list = {}
#    @on_arv = {}
#    @enrollments = {}
#    #    render (:inline => "<%= debug(@ptvisits.length) %>") and return false
#    @ptvisits.each do | visit |
#      @arv_status.inc(visit.arv_status)
#      @anti_tb_status.inc(visit.anti_tb_status)
#      # tag patient as on ARV in this time period if the visit arv status is begin, continue, or change
#      @on_arv[visit.pepfar] = 'Y' if ['B', 'C', 'V'].include? visit.arv_status
#      @patient_list[visit.pepfar] = ''
#      @enrollments[visit.pepfar] =  visit.name if visit.firstvisit > 0
#    end
##    render (:inline => "<%= debug(@patient_list.keys.sort) %>") and return false
#  end
#
#  def make_growthchart
#    @ptvisit = Ptvisit.find(params[:id])
##  render(:inline => "<%= debug(@ptvisit.patient) %>") and return
#    growth_chart_filename = @ptvisit.patient.growth_chart
#    send_file growth_chart_filename, :type => 'image/png', :disposition => 'inline'
#
#  end
end
