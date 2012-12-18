# Include this module to Rails controllers using ActiveScaffold to be able to receive 
# form parameters in normal Rails format ( {... model: {...}}) and change them to the
# format needed by AS ({... record:{...}})
# The module adds do_update and do_create methods, so these should not be overridden
# in the controller (unless the same functionality is added). Instead, you can override
# my_do_update and my_do_create, which are called by do_create and do_update just before
# they call the AS methods.
# The model name is determined from the controller class in @my_model_sym, which can be 
# overridden if the model name should be something else.

module StdToActivescaffoldAdapter

  # Get model symbol (e.g. :visit) from controller name (e.g. VisitsController)
  def my_model_sym
    # Override if this doesn't give the right symbol
    @my_model_sym ||= self.class.to_s.sub('Controller','').singularize.downcase.to_sym
  end

  def my_do_update
    # Override in controller to further modify state before calling AS update
  end

  def my_do_create
    # Override in controller to further modify state before calling AS create
  end

  def do_update
    params[:record] = params[my_model_sym]
    params.delete my_model_sym
    my_do_update
    super  # AS does the actual update
  end

  def do_create
    params[:record] = params[my_model_sym]
    params.delete my_model_sym
    my_do_create
    super  # AS does the actual create action
  end


end