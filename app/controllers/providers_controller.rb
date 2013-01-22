class ProvidersController < ApplicationController
  active_scaffold :provider do |config|
    config.list.columns = :last_name, :first_name, :middle_name, :ident, :title, :degree, :position
    as_no_inline = lambda do |action|
      config.send(action).link.page = true
      config.send(action).link.inline = false
    end
    %w(create update show).each &as_no_inline
    %w(title degree position).each {|col| config.columns[col].inplace_edit = true}
  end

  def new
    @provider = Provider.new #ToDO Error checking!
  end

  def create
    @provider = Provider.new(params[:provider])
    # binding.pry
    if @provider.save
      flash[:notice] = "Created new provider #{@provider}"
      @record = @provider # ToDo -- only while AS is handling :show
      render :show
    else
      params=nil
      render :new
    end
  end

  def edit
    @provider = Provider.find params[:id]
  end

  def update
    @provider = Provider.find params[:id]
    if @provider.update_attributes(params[:provider])
      flash[:notice] = 'Provider updated'
      redirect_to provider_path(@provider.id)
    else
      render :update
    end
  end

end
