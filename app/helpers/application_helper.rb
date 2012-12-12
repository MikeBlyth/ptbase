module ApplicationHelper
  def present(object, klass=nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    return presenter
  end

  def date_column(record, column)
    record.date.to_s(:default)
  end

end
