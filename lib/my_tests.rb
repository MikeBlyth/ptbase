class MyTests
  def tr( x, &block)
    yield(x, x > 0 ? 'positive' : 'negative')
  end
end

class AxisT
  include Enumerable

  def initialize(init_hash)
    @hash = HashWithIndifferentAccess.new(init_hash)
  end
end

require 'delegate'
# Using DelegateClass
# a = AxisE.new(label: "Title") #=> {:label=>"Title", :title=>{:text=>"Title"}}
#    -- how is it different from < Hash? (see next example)
#    I don't know why DelegateClass does assign :label=>'Title', ...
class AxisE < DelegateClass(Hash)
  def initialize(params)
    super
    self[:title] = {text: params[:label]}
  end
end

# Simple subclassing.
# a = AxisHash.new(label: "Title") #=> {:title=>{:text=>"Title"}}
# Note that Hash does not assign the params to the object itself (no :label key), since Hash.new doesn't.
class AxisHash < Hash
  def initialize(params)
    super
    self[:title] = {text: params[:label]}
  end
end


#SimpleDelegator -- again, how is this different from DelegateClass?
# a = AxisSD.new(label: "Title") #=> {:label=>"Title", :title=>{:text=>"Title"}}
class AxisSD < SimpleDelegator
  def initialize(params)
    super
    self[:title] = {text: params[:label]}
  end
end


# USING FORWARDABLE
# This one only associates the specific methods. See doc for the other syntax for 'delegate'
class AxisForwardable
  extend Forwardable
  delegate [:[], :[]=, :merge, :merge!] => :@data
  def initialize(params)
    @data = params
    @data[:title] = {text: params[:label]}
  end
end

require 'abstract_chart'
include AbstractChart

c = Chart.new
ax = Axis.new({orientation: :x, name: :age, min: 0, max: 18})
ay = Axis.new({orientation: :y, name: :weight, min: 0, max: 100})
az = Axis.new({orientation: :y, name: :height, min: 40, max: 180})
c.add_axis ax
c.add_axis ay
c.add_axis az
puts c.render_axes_to_highchart
