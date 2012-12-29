class PrescriptionsController < ApplicationController

  active_scaffold :prescription do |config|
    config.list.columns = :patient, :date, :provider, :prescription_items
    config.create.link.page = true
    config.create.link.inline = false
    config.update.link.page = true
    config.update.link.inline = false
  end

  include StdToActivescaffoldAdapter # NB THIS MUST COME *AFTER* THE active_scaffold configuration!

  def new
    @patient = Patient.find params[:patient_id]
    @prescription = @patient.prescriptions.new(provider_id: current_user.id)
    blank_prescription_item_count = 2
    blank_prescription_item_count.times { @prescription.prescription_items <<  PrescriptionItem.new}

#    super
#binding.pry
  end

  def edit
puts "edit - params=#{params}"
    @prescription = Prescription.find(params[:id])
    @patient = @prescription.patient
  end

  def create
    puts "Create - params=#{params}"
#    binding.pry
    rx_attributes = params[:prescription]
    rx = Prescription.new rx_attributes
    if rx.save
      flash[:notice] = 'Prescription saved successfully'
      redirect_to prescription_path(rx)
    else
      puts "Errors: #{rx.errors.messages}"
      @prescription = rx
      render :new
    end
  end

  def update
    puts "update - params=#{params}"
    rx = Prescription.find params[:id]
#    binding.pry
    rx_attributes = params[:prescription]
    if rx.update_attributes rx_attributes
      flash[:notice] = 'Prescription updated successfully'
      redirect_to prescription_path(rx)
    else
      puts "Errors: #{rx.errors.messages}"
      @prescription = rx
      render :edit
    end
  end

  ########## FROM ORIGINAL APP ################
#  def show
##    render(:inline => "<%= debug(@params[:evan_rx]) %>") and return
#    @editing = false
#    @prescription = Prescription.find(params[:id])
#    @patient = @prescription.patient
#    @visit = Ptvisit.find(params[:visit]) if params[:visit]
#    @items = @prescription.prescription_items()
#    @items = PrescriptionItem.find_all_by_prescription_id(@prescription.id, :order => "sorting")
##render(:inline => "<%= debug(@items) %>") and return
#    @age = time_human(@patient.age_on_date(@prescription.date))
##    render(:inline => "<%= debug(@prescription) %>") and return
#    @bsa = bsa(@prescription.weight, @prescription.height)
##    render(:inline => "<%= debug(@prescription.prescription_items[0]) %>") and return
##    rescue
##    	flash[:notice] = 'Prescription number not found'
##    	redirect_to(:action => 'list')
#    if params[:evan_rx] == '1'
#      render :template => 'prescription/show_evan'
#      return
#    end
#  end
#
#  def show_pepfar
#    @editing = false
#    @prescription = Prescription.find(params[:id])
#    @patient = @prescription.patient
#    @visit = Ptvisit.find(params[:visit]) if params[:visit]
#    @items = @prescription.prescription_items()
#    @items = PrescriptionItem.find_all_by_prescription_id(@prescription.id, :order => "sorting")
#    @age = time_human(@patient.age_on_date(@prescription.date))
#    @bsa = bsa(@prescription.weight, @prescription.height)
#    # Now we need to pack the prescription items into labeled bins for the ugly Evangel Pepfar prescription forms
#    # ARV's are separated and will be called out by name where required on the form.
#    @d = {}        # I'm going to use a really short variable name because we'll use it so much in the output
#    arv_names = %w{ lamivudine zidovudine stavudine didanosine kaletra nevirapine efavirenz }
#    @items.each do | an_item |
#      an_item[:drug] =~ /(\w*)/       # use only first word of the drug name ... note this if you're changing things
#      basename = $&.downcase             # i.e., the first word (up to the end of :drug, or to the first non-word character
#      @d[basename.to_sym] = an_item          # now we have all the same items, but "named" for easy access
#    end
#  end
#
#
#  def edit
#    # Presently, editing is somewhat of a kludge (messy programming). This involves methods edit and update.
#    # The main reason is the "back button" problem. If the user performs an edit and presses the
#    # save changes button, he's taken to the "show" page. If he then uses the back key to go back
#    # and change something again, the page is stale and pressing the save key again will try to
#    # delete the wrong prescription. Using the no_cache layout prevents this in IE but not
#    # (yet) in Firefox, so we can trap this situation only after the save changes has been pressed
#    # on the stale page. We'll discover that the "old prescription" can't be found (since it was
#    # deleted after the first edit). In this case, an error message is put into the :flash and
#    # the listing for this patient's prescriptions is displayed (since we no longer know which one
#    # was being edited; we would know if the edit link was used, but it wasn't).
#    #
#    # Overall, the flow in editing a prescription is this:
#    #   Find the existing prescription, which will now be called the old prescription.
#    #   Create the @doses object from the old prescription items
#    #   Render the edit page, which uses the common _form.rhtml the same as for new
#    #   The filled form is posted to the update method.
#    #   Update creates a new prescription and tries to save it.
#    #   If the save is successful, the old prescription is deleted.
#    #   Otherwise, the info is put back into the @doses object and the edit page is re-presented.
#    # In summary, a new prescription is created from the one to be edited, and when it is successfully
#    # saved, the old one is deleted.
#    @prescription = Prescription.find_by_id(params[:id]) # use find_by_id since find may fail (back-button)
#                                                         # Back-button with non-cached page causes this method to run again, but the prescription will have been deleted.
#    if @prescription.nil?   # we didn't find the prescription we're supposedly editing, ...
#      render(:inline => "<h2>Missing prescription.</h2>" +
#          "<p>Please use the <em>Edit</em> link, not the Back Button, to edit prescriptions. " +
#          "Click the Forward button to return to viewing prescription.</p>") and return false
#    end
#    if @prescription.confirmed != 0
#      if @prescription.voided != 0
#        flash[:notice] = 'A confirmed prescription cannot be changed or deleted, and this one is already voided.'
#      else
#        flash[:notice] = 'A confirmed prescription cannot be changed or deleted, but you can void it if it has not been dispensed.'
#      end
#      redirect_to :action => 'show', :id => @prescription
#      return false
#    end
#    @editing_id = @prescription.id # This is the number of the existing prescription being edited/replaced. Stored in the form.
#    @patient = @prescription.patient
#    @weight = @prescription.weight
#    @height = @prescription.height
#    @bsa = bsa(@prescription.weight, @prescription.height) || '?'
#    @doses = prescribed_doses(@prescription.prescription_items) # load the information from existing items
#    add_blank_items(@doses, 2)
#    render(:layout => 'no_cache') # no_cache, so back-button should not work w local cache
#  end
#
#  def update # "update" by creating a new prescription and replacing the the existing one
#    @prescription_old = Prescription.find_by_id(params[:id]) # This ':id' is from the @editing_id, by way of the start_form_tag
#    if @prescription_old.nil? # Not found, so probably has been deleted and user has used back button to try to edit the same prescription again
#      flash[:notice] = 'Missing presription. You probably used the back button to edit a prescription. Please use the <em>Edit</em> link instead.'
#      redirect_to :action => 'list', :id => params[:patient_id] # :patient_id is stored in form just for this purpose
#      return
#    end
#                                                             # Now we have a legitimate edit. Create a new prescription, attach new items, and try to save.
#    @patient = @prescription_old.patient
#    @prescription = Prescription.new(:reckey => @patient.id, :prescriber_id => session[:user_id],
#                                     :prescriber => params[:prescriber],
#                                     :date => my_date_parse(params[:date]),
#                                     :weight => params[:weight], :height => params[:height],
#                                     :override_warning => params[:override_warning],
#                                     :voided => false, :confirmed => false )
#
#    items = make_items_from_param_hash(params)
#                                                             # Now validate the items ... (if not to be done by model's validate methods)
#    @prescription.prescription_items.push(*items)   # attach items to the parent prescription
#    if @prescription.save   # Try to save the new prescription with items. If successful, delete the old one.
#      @prescription_old.destroy
#      flash[:notice] = 'Prescription was successfully modified.'
#      redirect_to  :action => 'show', :id => @prescription
#    else  # we couldn't save, so there was an error. Set up message, and return to the edit form.
#      flash[:notice] = 'Problem ...'
##          render(:inline => "<%= error_messages_for(:prescription) %>") and return
#      @prescription.prescription_items.each do | p_item |
#        flash[:notice] = flash[:notice] + '<br>Check ' + p_item.drug if p_item.errors.any?
#        @p = p_item
#      end
#      get_weight_height
#      @doses = prescribed_doses(@prescription.prescription_items)
#      @editing_id = @prescription_old.id
#      add_blank_items(@doses, 2)
#      render :action => 'edit'
#    end
#  end
#
#  def new         # give the user a form with suggested drugs and doses to choose from.
#    @patient = Patient.find(params[:id])
#    get_weight_height                                    # sets up globals for weight, height, bsa
#    @selected = params[:selected] || []                  # need to use empty array if no drugs already selected
#    @preselect = ! @selected.empty?         # means user has preselected drugs, so we'll "tick" each one's box on prescr. form
#    @doses = suggested_doses(@selected)
#    @prescription = Prescription.new(:reckey => @patient.id, :prescriber_id => session[:user_id],
#                                     :prescriber => '',
#                                     #                                                  :prescriber => session[:name],
#                                     :date => Time.now.strftime("%d-%b-%Y"),
#                                     :weight => @weight, :height => @height,
#                                     :voided => false, :confirmed => false )
#  end
#
#
## This is how the parameter hash looks on entering create when the prescription _form is submitted.
## Prescription items to be saved are first shown by an item_name => 'select' pair (as in first line
## below). Then the parameters for that item are in the form "item_name;parameter: => value", so the
## hash key is the item_name + ';' + parameter.
##      "#other0": select
##      "#other0;duration": "5"
##      "#other0;instr": Instructions for taking amoxil
##      "#other0;interval": "8"
##      "#other0;liquid": "25"
##      "#other0;name": amoxacillin
##      "#other0;quant": "125"
##      "#other0;sorting": ""
##      "#other0;unit": mg
##      "#other0;use_liquid": "1"
##      "#other1;duration": ""
##      "#other1;instr": ""
##      "#other1;interval": "24"
##      "#other1;liquid": ""
##      "#other1;name": ""
##      "#other1;quant": ""
##      "#other1;sorting": ""
##      "#other1;unit": mg
##      action: create
##      bsa: "0.413655788199695"
##      commit: Prescribe
##      controller: prescription
##      date: 23-Feb-2007
##      Fansidar: select
##      Fansidar;duration: "1"
##      Fansidar;instr: ""
##      Fansidar;interval: "0"
##      Fansidar;name: Fansidar
##      Fansidar;quant: "0.5"
##      Fansidar;sorting: M_3
##      Fansidar;unit: tab
##      height: "88.0"
##      patient: "999999"
##      prescriber: b
##      weight: "7.0"
#  def make_items_from_param_hash(params)
## Make an array of new prescription items from the params returned by the new/edit _form.
## We use new rather than create (which saves them in the database) because the items have to be checked
## for validity after they have all been created (looking for interactions). We don't associate the
## items with the parent prescription yet, because once they're validated, we'll have to delete any
## existing (saved) items for the parent prescription before saving these new ones (applies to edit, not new).
##
## NB: The parameters are all _manually_ specified in this method, so that if new fields (columns) are added to
## the prescription_item model, they need to be incorporated into this method.
##
#    items = []
#    params.each do | key, value |         # look for drugs to add
#      next unless value == 'select'     # this is how we are flagging the selected drugs
#                                        # now key is a selected item
#      items << PrescriptionItem.new(
#          :drug => params[key+';name'],     # may want to change this to something more unique
#          :dose => params[key+';quant'],    # find the different parameters for this drug among the params hash
#          :units => params[key+';unit'],
#          :interval => params[key+';interval'].to_i,
#          :duration => params[key+';duration'],
#          :other_description => params[key+';description'],
#          :other_instructions => params[key+';instr'],
#          :liquid => params[key+';liquid'],
#          :filled => 'false',
#          :route => 'po',
#          :sorting => params[key+';sorting'],
#          :use_liquid => params[key+';use_liquid'] || 0
#      )
#    end
#    return items
#  end
#
#  def create
#    # render(:inline=> "<%= debug(params)%>") and return false
#    @patient = Patient.find(params[:patient])
#    @prescription = Prescription.new(:reckey => @patient.id, :prescriber_id => session[:user_id],
#                                     :prescriber => params[:prescriber],
#                                     :date => my_date_parse(params[:date]),
#                                     :weight => params[:weight], :height => params[:height],
#                                     :override_warning => params[:override_warning],
#                                     :voided => false, :confirmed => false )
#
#    items = make_items_from_param_hash(params)
#    # Now validate the items ... (if not to be done by model's validate methods)
#    # Now attach them all to the parent prescription
#    #  @x = items; render(:inline=> "<%= debug(@x)%>" ) and return
#    @prescription.prescription_items.push(*items)
#    if @prescription.save   # find the right one, try to save it
#      flash[:notice] = 'Prescription was successfully created.'
#      redirect_to  :action => 'show', :id => @prescription
#    else
#      flash[:notice] = 'Problem ...'
##          render(:inline => "<%= error_messages_for(:prescription) %>") and return
#      @prescription.prescription_items.each do | p_item |
#        flash[:notice] = flash[:notice] + '<br>Check ' + p_item.drug if p_item.errors.any?
#        @p = p_item
##            render(:inline => "<%= @p.errors.methods.join(' ') %>") and return if p_item.errors
##            render(:inline => "<%= @p.errors.any? %>") and return if p_item.errors
#      end
#      get_weight_height
#      @doses = item_to_suggested(@prescription.prescription_items)
#      render :action => 'new'
#    end
#  end
#
#  def duplicate  # duplicate current prescription, with new date
#    source_prescription = Prescription.find(params[:id])
#    new_prescriber = params[:new_prescriber]
#    new_prescriber = '?' if new_prescriber.blank?
#    @s = source_prescription
#    @patient = source_prescription.patient
#    @prescription = Prescription.create(:reckey => @patient.id, :prescriber_id => session[:user_id],
#                                        :prescriber => new_prescriber,
#                                        :date => Time.now.strftime("%d-%b-%Y"),
#                                        :weight => @weight, :height => @height,
#                                        :voided => false, :confirmed => false )
#    @pcolumns = PrescriptionItem.column_names
#    @pcolumns.delete('updated_at')
#    @pcolumns.delete('created_at')
#    @pcolumns.delete('prescription_id')
#    @pcolumns.delete('id')
#    # Now duplicate all the items from the source
#    #        render(:inline => "<%= debug(@prescription) %>") and return false
#    source_prescription.prescription_items.each do | item |
#      pdata = {}  # this is where we'll keep the data extracted from the items being duplicated
#                  # get the value of each piece of data (column) in the prescription item
#      @pcolumns.each do | col_name |
#        pdata[col_name] = item.send(col_name)
#      end
#      @new_item = PrescriptionItem.new(pdata)
#                  #         render(:inline => "<%= debug(@new_item) %>") and return false
#      @prescription.prescription_items.push(@new_item)    # link the new item to the new prescription
#    end
#    @prescription.save
#    #      render(:inline => "<%= debug(@s.prescription_items) %>") and return false
#    #      render :action => 'show'
#    redirect_to :action => 'show', :id => @prescription
#  end
#
#
#
#  def confirm    # receives a prescription number (id) which user has confirmed
#    @editing = false
#    Prescription.update(params[:id], :confirmed => true)
#    redirect_to :action => 'show', :id => params[:id]
#  end
#
#  def void    # Mark a prescription as voided
#    @editing = false
#    Prescription.update(params[:id], :voided => true)
#    redirect_to :action => 'show', :id => params[:id]
#  end
#
#  def unvoid    # Mark an existing prescription as unvoided
#    @editing = false
#    @prescription = Prescription.find(params[:id])
#    @prescription.voided = false;
#    @prescription.prescriber = '?' if @prescription.prescriber.blank?
#    @prescription.save
##      render(:inline => "<%= debug(@prescription) %>") and return false
#    redirect_to :action => 'show', :id => params[:id]
#  end
#
#  def destroy
#    visit = params[:visit]
#    @editing = false
#    prescription = Prescription.find(params[:id])
#    patient = prescription.patient
#    if prescription.confirmed != 0
#      if prescription.voided != 0
#        flash[:notice] = 'A confirmed prescription cannot be deleted, and this one is already voided.'
#      else
#        flash[:notice] = 'A confirmed prescription cannot be deleted, but you can void it.'
#      end
#      redirect_to :action => 'show', :id => prescription
#    else
#      prescription.destroy
#      if visit
#        redirect_to(:controller => 'visit', :action => 'show', :id => visit)
#      else
#        redirect_to(:action => 'list', :id => patient)
#      end
#    end
#  end
#
#  def get_weight_height
#    @x = 1
#    @x = wt_last_hash = @patient.get_last(@patient.ptvisits, "weight")
#    if (wt_last_hash.nil?) || (wt_last_hash[:value] == 0 )
#      flash[:notice] = 'Cannot generate suggested doses because there are no recent weights recorded for patient'
#      redirect_to :controller => 'admin', :action => 'show', :id => @patient
#      return
#    end
#    wt, wt_date = wt_last_hash[:value], wt_last_hash[:date]
#    ht_last_hash = @patient.get_last(@patient.ptvisits, "ht")
#    ht, ht_date = ht_last_hash[:value], ht_last_hash[:date] if ht_last_hash   # might be missing (nil), else store ht & date
#    bsa_pt = bsa(wt, ht)          # defined in application.rb
#    @weight, @height, @bsa = wt, ht, bsa_pt    # this makes them available to the view
#                                               # *** insert here logic to check for "latest" height and weight that are too outdated
#  end
#
#  def item_to_suggested(p_items)    # another ugly hack til we get things under control -- use prescription_items to make a suggested_return type object
#    suggested_return = []
#    p_items.each do | p |
#      suggested_return << { :name => p.drug,
#                            :code => p.drug,
#                            :dose_rounded => p.dose,
#                            :liquid => p.liquid,
#                            :use_liquid => p.use_liquid,
#                            :duration => p.duration,
#                            :units => p.units,
#                            :interval => p.interval,
#                            :other_description => p.other_description,
#                            :other_instructions => p.other_instructions,
#                            :route => p.route,
#                            :select => true
#      }
#    end
#    return suggested_return
#  end
#
#  def test_recent
#    @patient = Patient.find(params[:id])
##    render(:inline => "<%= debug(@patient.current_drugs) %>")
#    render(:inline => "<%= @patient.current_drugs_formatted %>")
#  end
#
#  # select which drugs to be presented on new prescription form -- so we don't have to see everything at once
#  def select
#    @patient = Patient.find(params[:id])
#    @select_from = [
#        ['Anti-TB', %w{ Isoniazid Pyridoxine Rifampacin Pyrazinamide Ethambutol }],
#        ['Anti-Malaria', %w{ Chloroquine Artesunate Fansidar Quinine }],
#        ['OI and Misc', %w{ Septrin Multivits Fluconazole Nystatin_oral Chlorpheniramine Amoxycillin Augmentin Erythromycin Paracetamol Albendazole Griseofulvin Flagyl_amoeba Flagyl_giardia}],
#        ['NRTI', %w{ Zidovudine Lamivudine Stavudine Didanosine }],
#        ['NNRTI', %w{ Nevirapine_start Nevirapine_cont Efavirenz}],
#        ['Protease Inh', %w{ Kaletra }]
#    ]
#  end
#
#  # receive results of checking boxes for which drugs to include in prescription. Selected drugs will be found in params
#  # as hash elements with the key being the name, and the value being 1
#  def process_select
##    render(:inline => "Hello World") and return false
##    render(:inline => "<%= debug(params) %> <%= debug(@patient)%>") and return false
#    selected = []
#    if params.include?(:select)
#      params[:select].each do | p, val |        # look for key-value pairs with value == 1, and add those keys to list of selected drugs
#        selected << p if val == '1'
#      end
#    end
#    params[:selected] = selected
#    redirect_to :action => :new, :id => params[:patient], :selected => selected
#  end
#
#  def prescribed_doses(p_items)
#    # Given an array of prescription items, create a "doses" object of the same format as suggested_doses
#    # creates. This "doses" can then be passed to the same form (_form) used by 'new'.
#    # NB: This could all be simplified by using an actual prescription_item object in both suggested_doses and
#    # this prescribed_doses, making adjustments as needed to the format.
#    doses = []
#    for item in p_items
#      doses <<   {:name => item.drug,
#                  :dose_rounded => item.dose,
#                  :interval => item.interval,
#                  :unit => item.units,
#                  :use_liquid => item.use_liquid,
#                  :liquid => item.liquid,
#                  :duration => item.duration,
#                  :instructions => item.other_instructions,
#                  :route => item.route,
#                  :sorting => item.sorting,
#                  :description => item.other_description,
#                  :select => true,
#                  :type => :prescribed
#      }
#    end
#    return doses
#  end
#
#  def suggested_doses(selected={})
#    # return an array of suggested doses based on patient's height and weight, in form like
#    # [ {:name => 'Lamivudine', :dose_rounded => 60, :dose_exact => 57, :unit => "mg", :interval => 12 }, ...
#    # using a hash means we can easily add pieces as needed
#    # The array will be ordered in the order that the individual drug-dose-hashes are added.
#    # If there are any drug names in selected, then only those will be included in the suggestions
#    patient = @patient
#    age = patient.age_in_years
#    weight, height, bsa_pt = @weight, @height, @bsa      # just to let us have flexibility of using these names for same vars
#    wt, ht = weight, height
#    return [] if wt.nil?
#    suggested_return = []
#
#    # Headings are modeled as below. :display can be 'none' (default), 'block' (show initially in browser) or ....?
#
#    suggested_return << {:heading => "NRTI", :display => 'block'}
#
#    # Lamivudine, the easiest
#    if selected.include?('Lamivudine')
#      suggested = {}  # collect the name, the corresponding suggested dose
#      suggested[:name] = 'Lamivudine'
#      suggested[:code] = 'Lamivudine'
#      suggested[:sorting] = 'A_1_2'
#      exact = wt * 4    # 4 mg/kg/dose
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when exact.between?(60,80) then 75
#                                   when exact < 115 then round_to(exact+3,10)
#                                   when exact >= 115 then 150
#                                 end
#      suggested[:interval] = 12  # q 12 hours
#      suggested[:unit] = 'mg'
#      suggested[:liquid] = 10   # 10 mg/ml
#      suggested[:duration] = 30
#      suggested[:use_liquid] = (exact < 60) || (exact.between?(80, 120))
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # d4T
#    if selected.include?('Stavudine')
#      suggested = Hash.new
#      suggested[:name] = 'Stavudine'
#      suggested[:code] = 'Stavudine'
#      suggested[:sorting] = 'A_1_1'
#      exact = wt    # 1 mg/kg bid (160 mg/m2 q8h)
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when exact.between?(0,12) then exact.ceil
#                                   when exact.between?(12,16) then 15
#                                   when exact.between?(16,22) then 20
#                                   when exact.between?(22,26) then 25
#                                   when exact > 26 then 30
#                                 end
#      suggested[:interval] = 12  # q 12 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = false
#      suggested[:liquid] = 1   # 1 mg/ml
#      suggested[:duration] = 30
#      suggested[:comment] = ". *** Stavudine liquid is not stable unless refrigerated ***."
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Didanosine
#    if selected.include?('Didanosine')
#      suggested = Hash.new
#      suggested[:name] = 'Didanosine'
#      suggested[:code] = 'Didanosine'
#      suggested[:sorting] = 'A_1_4'
#      exact = 120 * bsa_pt    # 240 mg/m2/dose bid (160 mg/m2 q8h)
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when exact.between?(0,45) then round_to(exact,10)
#                                   when exact.between?(45.0001,150) then round_to(exact, 25)
#                                   when exact > 150 then 150
#                                 end
#      suggested[:interval] = 12  # q 12 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (exact < 50)
#      suggested[:liquid] = 10   # 10 mg/ml
#      suggested[:duration] = 30
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Zidovudine
#    if selected.include?('Zidovudine')
#      suggested = Hash.new
#      suggested[:name] = 'Zidovudine'
#      suggested[:code] = 'Zidovudine'
#      suggested[:sorting] = 'A_1_1'
#      exact = 240 * bsa_pt    # 240 mg/m2/dose bid (160 mg/m2 q8h)
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when exact.between?(0,130) then round_to(exact,10)
#                                   when exact.between?(130.0001,170) then 150
#                                   when exact.between?(170,220) then round_to(exact,10)
#                                   when exact > 220 then 300
#                                 end
#      suggested[:interval] = 12  # q 12 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (exact < 120)
#      suggested[:liquid] = 10   # 10 mg/ml
#      suggested[:duration] = 30
#      suggested_return << suggested  # add completed hash to the list of suggestions
#      if bsa_pt.between?(0.5, 0.75) && weight.between?(12, 19)
#        suggested = Hash.new
#        suggested[:name] = "Combivir"
#        suggested[:unit] = 'tab'
#        suggested[:dose_rounded] = 0.5
#        suggested[:interval] = 12  # q 12 hours
#        suggested[:duration] = 30
#        suggested[:comment] = ". Consider 1/2 Combivir bd <em>in place of</em> zidovudine/lamivudine."
#        suggested[:select] = false
#        suggested_return << suggested
#      end
#
#      if bsa_pt.between?(0.75, 1.12) && weight.between?(19, 28)
#        suggested = Hash.new
#        suggested[:name] = "Combivir"
#        suggested[:unit] = 'tab'
#        suggested[:dose_rounded] = 0.5
#        suggested[:interval] = 8  # q 8 hours
#        suggested[:comment] = "Consider 1/2 Combivir 3 times daily <em>in place of</em> zidovudine/lamivudine. "
#        suggested[:duration] = 30
#        suggested[:select] = false
#        suggested_return << suggested
#      end
#
#      if bsa_pt > 1.0 && weight > 25
#        suggested = Hash.new
#        suggested[:name] = "Combivir"
#        suggested[:dose_rounded] = 1
#        suggested[:unit] = 'tab'
#        suggested[:interval] = 12  # q 12 hours
#        suggested[:comment] = "Consider 1 Combivir bd <em>in place</em> of zidovudine/lamivudine. "
#        suggested[:duration] = 30
#        suggested[:select] = false
#        suggested_return << suggested
#      end
#    end
#
#    suggested_return << {:heading => "NNRTI", :display => 'block'}
#
#    if selected.include?('Nevirapine_start')
#      # Nevirapine -- Initial
#      suggested = Hash.new
#      suggested[:name] = 'Nevirapine--initial'
#      suggested[:code] = 'Nevirapine'
#      suggested[:sorting] = 'A_2'
#      suggested[:comment] = '(daily x 2 wk then increase to bd. 120 mg/m2). '
#      exact = 120 * bsa_pt    # 120 mg/m2/dose bd or qd
#      suggested[:dose_exact] = exact
#      rounded = suggested[:dose_rounded] = case       # rounding
#                                             when exact.between?(0,80) then round_to(exact,10)
#                                             when exact.between?(80,115) then 100
#                                             when exact.between?(115.01,149.99) then round_to(exact,10)
#                                             when exact >= 150 then 200
#                                           end
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (rounded != 100) && (rounded != 200)
#      suggested[:liquid] = 10   # 10 mg/ml
#      suggested[:duration] = 14
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Nevirapine -- Standard
#    if selected.include?('Nevirapine_cont')
#      suggested = Hash.new  # there's probably a better way, but must do something to create a new object and not
#                            # simply overwrite the last one
#      suggested[:name] = 'Nevirapine--std'
#      suggested[:code] = 'Nevirapine'
#      suggested[:sorting] = 'A_2'
#      per_m2 = case
#                 when age < 4 then 200
#                 when age.between?(4,8) then 150
#                 when age > 8 then 120
#               end
#      suggested[:comment] = "(#{per_m2} mg/m<sup>2</sup> bd). "
#      exact = per_m2 * bsa_pt
#      exact = 200 if exact > 200       # 200 mg is the maximum standard dose
#      suggested[:dose_exact] = exact
#      rounded = suggested[:dose_rounded] = case       # rounding
#                                             when exact.between?(0,80) then round_to(exact,10)
#                                             when exact.between?(80,110) then 100
#                                             when exact.between?(110.001,140) then round_to(exact,10)
#                                             when exact > 140 then 200
#                                           end
#      suggested[:interval] = 12  # q 12 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (rounded < 80) || (rounded.between?(110, 150))
#      suggested[:liquid] = 10   # 10 mg/ml
#      suggested[:duration] = 30
#      if bsa_pt.between?(0.71,0.83)
#        suggested[:comment] << "Consider 100 mg (1/2 tablet) 3 times daily. "
#      end
#      if bsa_pt.between?(0.48,0.57)
#        suggested[:comment] << "Consider 100 mg (1/2 tablet) 2 times daily. "
#      end
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # EFV
#    if selected.include?('Efavirenz')
#      suggested = Hash.new
#      suggested[:name] = 'Efavirenz (Stocrin)'
#      suggested[:code] = 'Efavirenz'
#      suggested[:sorting] = 'A_2'
#      suggested[:dose_rounded] = case       # rounding
#                                   when weight < 10 then "? "
#                                   when weight.between?(10,15) then 200
#                                   when weight.between?(15,20) then 250
#                                   when weight.between?(20,25) then 300
#                                   when weight.between?(25,32.5) then 350
#                                   when weight.between?(32.5,40) then 400
#                                   when weight > 40 then 600
#                                 end
#      suggested[:dose_exact] = suggested[:dose_rounded]
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (wt < 10)
#      suggested[:liquid] = 30   # 30 mg/ml
#      if age < 3
#        suggested[:dose_exact] = 20*wt   # this is just a best estimate -- no recommendations available yet!
#        suggested[:dose_rounded] = round_to(suggested[:dose_exact], 7.5)  # 7.5 mg = 0.5 ml
#        suggested[:comment] = "<br>** Not recommended for children under 3 years old, use w caution ** "
#      end
#      suggested[:duration] = 30
#      suggested_return << suggested  # add completed hash to the list of suggestions
#
#      suggested_return << {:heading => "Protease Inhibitors", :display => 'block'}
#    end
#
#    # Kaletra
#    if selected.include?('Kaletra')
#      suggested = Hash.new
#      suggested[:name] = 'Kaletra (lpv/r)'
#      suggested[:code] = 'Kaletra'
#      suggested[:sorting] = 'A_3'
#      suggested[:dose_exact] = case
#                                 when weight < 15 then wt * 12      # 12 mg/kg
#                                 when weight >= 15 then wt * 10     # 10 mg/kg
#                               end
#      exact = suggested[:dose_exact]
#      suggested[:dose_rounded] = case       # rounding
#                                   when exact < 120 || age < 1.5 then round_to(exact,20)
#                                   when exact.between?(120,150) then 133
#                                   when exact.between?(220,290) then 266
#                                   when exact > 290 then 400
#                                   else  round_to(exact,40)
#                                 end
#      suggested[:interval] = 12  # q 12 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (exact < 120) || exact.between?(150,220) || age < 1.5
#      suggested[:liquid] = 80   # 80 mg/ml
#      suggested[:duration] = 30
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    suggested_return << {:heading => "Drugs for OI etc.", :display => 'block'}
#
#    if selected.include?('Cotrimoxazole') || selected.include?('Septrin')
#      # Cotrimoxazole (Doses based on TMP component)
#      suggested = Hash.new
#      suggested[:name] = 'Cotrimoxazole'
#      suggested[:code] = 'Cotrimoxazole'
#      suggested[:sorting] = 'B_1'
#      exact = wt.to_f / 20   # 4 mg/kg/dose
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when weight <= 10.5 then round_to(exact,0.1)
#                                   when weight.between?(10.5,14) then 0.5
#                                   when weight.between?(14,20) then 1
#                                   when weight.between?(20,30) then 1.5
#                                   when weight > 30 then 2
#                                 end
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'tab'
#      suggested[:use_liquid] = (weight < 10.5 )
#      suggested[:liquid] = 0.1   # 8 mg/ml, 0.1 tab/ml
#      suggested[:duration] = 30
#      suggested[:comment] = "Use daily for PCP prophylaxis, q12h for treatment of common infections, q6h for PCP"
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Nystatin oral suspension
#    if selected.include?('Nystatin_oral')
#      suggested = Hash.new
#      suggested[:name] = 'Nystatin oral susp'
#      suggested[:code] = 'Nystatin_oral'
#      suggested[:sorting] = 'B_2'
#      suggested[:dose_exact] = case       # rounding
#                                 when weight < 4 then 1
#                                 when weight.between?(4,25) then 2
#                                 when weight > 25 then 4
#                               end
#      suggested[:dose_rounded] = suggested[:dose_exact]
#      suggested[:interval] = 6  # q 6 hourly
#      suggested[:unit] = 'ml'
#      suggested[:duration] = 10
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Fluconazole
#    if selected.include?('Fluconazole')
#      suggested = Hash.new
#      suggested[:name] = 'Fluconazole'
#      suggested[:code] = 'Fluconazole'
#      suggested[:sorting] = 'B_3'
#      suggested[:dose_exact] = exact = [wt * 3, 200].min
#      suggested[:dose_rounded] = case       # rounding
#                                   when exact < 40 then round_to(exact, 10)
#                                   when exact.between?(40, 60) then 50
#                                   when exact.between?(60.001, 120) then 100
#                                   when exact.between?(120, 170) then 150
#                                   when exact > 170  then 200
#                                 end
#      rounded = suggested[:dose_rounded]
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 10
#      suggested[:use_liquid] = (exact < 40)
#      suggested[:liquid] = 10   # 10 mg/ml
#      suggested[:instructions] = case
#                                   when exact < 100 then "Take double the dose (#{2*suggested[:dose_rounded]} mg) today only, then continue with #{rounded} mg daily."
#                                   when exact.between?(100,200) then "Take 200 mg today only then continue with #{rounded} mg daily."
#                                   when exact > 200 then nil
#                                 end
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Multivits
#    if selected.include?('Multivits')
#      suggested = Hash.new
#      suggested[:name] = 'Multivits'
#      suggested[:code] = 'Multivits'
#      suggested[:sorting] = 'Z_1'
#      suggested[:dose_exact] = suggested[:dose_rounded] = case       # rounding
#                                                            when age < 1.5 then 0.5
#                                                            when age > 1.5 then 1
#                                                          end
#
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:interval] = 12  if age > 3
#      suggested[:unit] = 'tab'
#      suggested[:use_liquid] = (age < 3 )
#      suggested[:liquid] = 0.2   # 5 ml ~ 1 tab
#      suggested[:duration] = 30
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # chlorpheniramine
#    if selected.include?('Chlorpheniramine')
#      suggested = Hash.new
#      suggested[:name] = 'Chlorpheniramine'
#      suggested[:code] = 'Chlorpheniramine'
#      suggested[:sorting] = 'Z_3'
#      suggested[:dose_exact] = suggested[:dose_rounded] = case       # rounding
#                                                            when age < 2 then round_to(0.09 * wt,0.4)
#                                                            when age.between?(2,6) then 1
#                                                            when age.between?(6,12) then 2
#                                                            when age > 12 then 4
#                                                          end
#
#      suggested[:interval] = 6    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (age < 12 )
#      suggested[:liquid] = 0.4   # 5 ml ~ 1/2 tab
#      suggested[:duration] = 14
#      suggested[:comment] = '(Piriton) Not recommended for children under 6 months old.'
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Amoxycillin
#    if selected.include?('Amoxycillin')
#      suggested = Hash.new
#      suggested[:name] = 'Amoxycillin'
#      suggested[:code] = 'Amoxycillin'
#      suggested[:sorting] = 'E_2'
#      exact = [wt*13, 500].min    # 13 mg/kg/dose = 39 mg/kg/day
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when exact < 175 then round_to(exact,25)
#                                   when exact.between?(175,275) then 250
#                                   when exact > 275 then 500
#                                 end
#      suggested[:interval] = 8  # q 8 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (age < 3 )
#      suggested[:liquid] = 25   # 25 mg/ml = 125 mg/5ml
#      suggested[:duration] = 7
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Augmentin
#    if selected.include?('Augmentin')
#      suggested = Hash.new
#      suggested[:name] = 'Augmentin'
#      suggested[:code] = 'Augmentin'
#      suggested[:sorting] = 'E_3'
#      exact = wt*10 # 10 mg/kg/dose = 30 mg/kg/day
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when exact < 175 then round_to(exact,25)
#                                   when exact.between?(175,275) then 250
#                                   when exact > 275 then 500
#                                 end
#      suggested[:interval] = 8  # q 8 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (age < 3 )
#      suggested[:liquid] = 25   # 25 mg/ml = 125 mg/5ml
#      suggested[:duration] = 7
#      suggested[:comment] = '*Dose based on amoxycillin component'
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Erythromycin
#    if selected.include?('Erythromycin')
#      suggested = Hash.new
#      suggested[:name] = 'Erythromycin'
#      suggested[:code] = 'Erythromycin'
#      suggested[:sorting] = 'E_4'
#      exact = [wt*13, 500].min    # 13 mg/kg/dose = 39 mg/kg/day
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when exact < 175 then round_to(exact,25)
#                                   when exact.between?(175,275) then 250
#                                   when exact > 275 then 500
#                                 end
#      if age < (1.0 / 12)  # Neonates, 30 mg/kg/day
#        suggested[:dose_exact] = suggested[:dose_rounded] = wt*10
#      end
#      suggested[:interval] = 8  # q 8 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (age < 3 )
#      suggested[:liquid] = 25   # 25 mg/ml = 125 mg/5ml
#      suggested[:duration] = 7
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#
#    suggested_return << {:heading => "Antimalarials", :display => 'block'}
#
#    # Chloroquine
#    if selected.include?('Chloroquine')
#      suggested = Hash.new
#      suggested[:name] = 'Chloroquine'
#      suggested[:code] = 'Chloroquine'
#      suggested[:sorting] = 'M_2'
#      exact = [wt*10, 600].min    # 10 mg/kg/dose, max 600 mg
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = rounded = case       # rounding
#                                             when exact < 120 then round_to(exact,10)
#                                             when exact.between?(120,160) then 150
#                                             when exact.between?(160, 250) then 225
#                                             when exact.between?(250,330) then 300
#                                             when exact.between?(330,500) then 450
#                                             when exact > 500 then 600
#                                           end
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (rounded < 150 )
#      suggested[:liquid] = 10   # 10 mg/ml
#      suggested[:duration] = 3
#      suggested[:comment] = 'Tablet = 150 mg, 1/2 tab = 75 mg, 1.5 tablet = 225 mg.'
#      suggested[:instructions] = "Use only half dose on third day."
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Artesunate
#    if selected.include?('Artesunate')
#      suggested = Hash.new
#      suggested[:name] = 'Artesunate'
#      suggested[:code] = 'Artesunate'
#      suggested[:sorting] = 'M_1'
#      exact = [wt*2, 100].min    #
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = rounded = case       # rounding
#                                             when exact < 20 then exact.round
#                                             when exact.between?(20,30) then 25
#                                             when exact.between?(30,60) then 50
#                                             when exact > 60 then 100
#                                           end
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:use_liquid] = (rounded < 50 )
#      suggested[:liquid] = 10   # 10 mg/ml
#      suggested[:duration] = 5
#      suggested[:comment] = ''
#      suggested[:instructions] = "Use double dose on first day"
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Fansidar
#    if selected.include?('Fansidar')
#      suggested = Hash.new
#      suggested[:name] = 'Fansidar'
#      suggested[:code] = 'Fansidar'
#      suggested[:sorting] = 'M_3'
#      exact = [wt*0.06, 3].min    #  0.06 tabs per kg ~= 1 tab per 15 kg
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when wt.between?(5,10) then 0.5
#                                   when wt.between?(10.001,20) then 1
#                                   when wt.between?(20.001, 30) then 1.5
#                                   when wt.between?(30.001, 45) then 2
#                                   when wt > 45 then 3
#                                 end
#      suggested[:interval] = 0     # 0 means 'stat'
#      suggested[:interval_freeze] = true       # lock out user from changing the frequency
#      suggested[:unit] = 'tab'
#                                  #	suggested[:liquid] = 10   # need to get info about syrup
#      suggested[:duration] = 1
#      suggested[:use_liquid] = false  # until we know more
#                                  #	suggested[:comment] = ""
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    suggested_return << {:heading => "Anti-TB Drugs", :display => 'block'}
#
#    # INH
#    if selected.include?('Isoniazid')
#      suggested = Hash.new
#      suggested[:name] = 'Isoniazid (INH)'
#      suggested[:code] = 'Isoniazid'
#      suggested[:sorting] = 'T_1'
#      exact = wt * 5    # 5 mg/kg/dose
#      suggested[:dose_exact] = exact
#      inh_dose_rounded = suggested[:dose_rounded] = case       # rounding
#                                                      when weight < 12 then round_to(exact,10)
#                                                      when weight.between?(12,15) then 75
#                                                      when weight.between?(15,30) then 150
#                                                      when weight.between?(30,45) then 225
#                                                      when weight > 45 then 300
#                                                    end
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 30
#      suggested[:comment] = 'Pyridoxine supplement recommended'
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Pyridoxine
#    if selected.include?('Pyridoxine')
#      suggested = Hash.new
#      suggested[:name] = 'Pyridoxine (B6)'
#      suggested[:code] = 'Pyridoxine'
#      suggested[:sorting] = 'T_2'
#      suggested[:dose_exact] = case
#                                 when weight < 30 then 25
#                                 else 50
#                               end
#      suggested[:dose_rounded] = suggested[:dose_exact]
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 30
#      suggested[:comment] = 'Recommended for pts on INH'
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # RIF
#    if selected.include?('Rifampacin')
#      suggested = Hash.new
#      suggested[:comment] = ''
#      suggested[:name] = 'Rifampacin'
#      suggested[:code] = 'Rifampacin'
#      suggested[:sorting] = 'T_3'
#      suggested[:dose_rounded] = 2 * inh_dose_rounded  # keep 2:1 ratio so fixed-dose combinations can be used
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 30
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Pyrazinamide
#    if selected.include?('Pyrazinamide')
#      suggested = Hash.new
#      suggested[:comment] = ''
#      suggested[:code] = suggested[:name] = 'Pyrazinamide'
#      suggested[:sorting] = 'T_4'
#      exact = wt * 25    # 25 mg/kg/dose
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = (5.333 * inh_dose_rounded).round  # keep ratio so fixed-dose combinations can be used
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 30
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Ethambutol
#    if selected.include?('Ethambutol')
#      suggested = Hash.new
#      suggested[:comment] = 'Use cautiously in children due to possible optic neuritis.'
#      suggested[:name] = 'Ethambutol'
#      suggested[:code] = 'Ethambutol'
#      suggested[:sorting] = 'T_5'
#      exact = wt * 13    # 13 mg/kg/dose
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = (3.667 * inh_dose_rounded).round  # keep ratio so fixed-dose combinations can be used
#      suggested[:interval] = 24    # daily = q24 hours
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 30
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#
#    suggested_return << {:heading => "Other", :display => 'block'}
#
#    # Paracetamol
#    if selected.include?('Paracetamol')
#      suggested = Hash.new
#      suggested[:comment] = ''
#      suggested[:code] = suggested[:name] = 'Paracetamol'
#      suggested[:sorting] = 'Z_2'
#      exact = wt * 15    # 25 mg/kg/dose
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when wt < 12 then exact
#                                   when wt.between?(12, 25) then 250
#                                   when wt > 25 then 500
#                                 end
#      suggested[:interval] = 4
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 7
#      suggested[:liquid] = 24
#      suggested[:use_liquid] = suggested[:dose_rounded] < 250
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
## Griseofulvin
#    if selected.include?('Griseofulvin')
#      suggested = Hash.new
#      suggested[:comment] = 'These doses are starting doses for tinea capitis or tinea corporis. Higher doses may be required. Suggested duration: 2-4 weeks for t. corporis, 4-8 weeks for t. capitis. Take with meals, ideally a fatty meal.'
#      suggested[:instructions] = "Give with a meal, a food with fat or oil if possible."
#      suggested[:code] = suggested[:name] = 'Griseofulvin'
#      suggested[:sorting] = 'Z_4'
#      exact = wt * 20    # 25 mg/kg/dose
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when wt < 12 then exact
#                                   when wt.between?(12, 17) then 250
#                                   when wt.between?(17.000001, 25) then 500
#                                   when wt > 25 then 500
#                                 end
#      suggested[:interval] = 24
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 14
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
## Albendazole
#    if selected.include?('Albendazole')
#      suggested = Hash.new
#      suggested[:comment] = 'For children > 2 years. For strongyloides, use 400 mg x 3 days.'
#      suggested[:code] = suggested[:name] = 'Albendazole'
#      suggested[:sorting] = 'Z_6'
#      suggested[:dose_exact] = 400
#      suggested[:dose_rounded] = 400
#      suggested[:interval] = 24
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 1
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    # Flagyl
#    if selected.include?('Flagyl_amoeba')
#      suggested = Hash.new
#      suggested[:comment] = 'This is the suggested dosing for treatment of amoeba infections'
#      suggested[:code] = suggested[:name] = 'Flagyl'
#      suggested[:sorting] = 'Z_6'
#      exact = wt * 15
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when wt < 12 then round_to(exact+10, 20)
#                                   when wt.between?(12, 17) then 200
#                                   when wt.between?(17.0001, 24) then 300
#                                   when wt.between?(24.0001, 34) then 400
#                                   when wt.between?(34.0001, 42) then 500
#                                   when wt > 42 then 600
#                                 end
#      suggested[:interval] = 8
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 10
#      suggested[:liquid] = 40
#      suggested[:use_liquid] = suggested[:dose_rounded] < 200
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#    if selected.include?('Flagyl_giardia')
#      suggested = Hash.new
#      suggested[:comment] = 'This is the suggested dosing for treatment of giardia infections'
#      suggested[:code] = suggested[:name] = 'Flagyl'
#      suggested[:sorting] = 'Z_6'
#      exact = wt * 6
#      suggested[:dose_exact] = exact
#      suggested[:dose_rounded] = case       # rounding
#                                   when exact < 90 then round_to(exact+10, 20)
#                                   when exact.between?(90.001, 120) then 100
#                                   when exact.between?(120.001, 180) then round_to(exact, 40)
#                                   when exact.between?(180.001, 240) then 200
#                                   when exact > 240 then 300
#                                 end
#      suggested[:interval] = 8
#      suggested[:unit] = 'mg'
#      suggested[:duration] = 7
#      suggested[:liquid] = 40
#      suggested[:use_liquid] = (suggested[:dose_rounded].modulo 100) > 0  # i.e. use liquid if dose not a multiple of 100
#      suggested_return << suggested  # add completed hash to the list of suggestions
#    end
#
#
#
#    # . . . do other drugs
#    # Other
#    add_blank_items(suggested_return, 2)
#
#    return suggested_return
#  end
#
#  def add_blank_items(dose_list,n)
#    n.times do | i |
#      dose_list << {:name=> '#other'+i.to_s, :liquid => 0}
#    end
#    return dose_list
#  end
#
#  private
#  def parse_key(s)   # given 'rx_n_key' return n and key
#    return nil unless s =~ /rx_([0-9]+)_(.*)/
#    return [$1, $2]
#  end
#
#  # update, or create, prescription item from items_hash, a hash with each value being a hash of parameters needed to create
#  # or update one prescription item. The key of the outer hash (1, 2, 3 ...) is not used here
#  #  {
#  #   1 => {:id => 27, :dose = 25, ... },
#  #   2 => {:id => '', :drug=>'amoxil', :dose => '25', :units => 'mg' ...}, ... }
#  #   ...
#  #  }
#  def update_items(prescription, items_hash)
##    render(:inline => "#{items_hash.inspect}") and return
#    @update_items_error = false
#    items_hash.each do | keynum, iparams |                  # keynum is irrelevant
#      update_ok = nil
#      # if a box is not ticked, it doesn't make it into the parameters, so we need to set the default as false
#      iparams[:use_liquid] = false unless iparams.include?('use_liquid')
#      if iparams['id'] != ''           # refers to existing record, since it has an id number
#        item = PrescriptionItem.find(iparams['id'])
#        update_ok = item.update_attributes(iparams)
#      else                       # a new record (item) since it does not have an id number
#        if iparams['drug'].to_s > ''
#          update_ok = prescription.prescription_items.create(iparams)
#        end
#      end
#      if update_ok != nil      # it will be nil if not an existing item or a new item with a drug name specified, i.e. blanks ==> nil
#                               #        render(:inline => "iparams = #{iparams.inspect}<br>Line: #{keynum} => new item #{item.inspect}" ) and return if keynum == '4'
#        @update_items_error = @update_items_error || (not update_ok)
#      end
#    end
#  end


end
