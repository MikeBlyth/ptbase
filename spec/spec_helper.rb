require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
puts "PREFORK"
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This section needed since JS drivers for RSpec/Capybara don't handle transactions

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  # require 'spork/ext/ruby-debug'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| puts "Requiring #{f}"; require f}

  RSpec.configure do |config|
    DatabaseCleaner.strategy = :truncation
    config.use_transactional_fixtures = false
    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = if example.metadata[:js]
                                   :truncation
                                 else
                                   :transaction
                                 end
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    # Following line doesn't seem to work. See comments in Railscast 287.
    # config.include ActionView::TestCase::Behavior, example: {file_path: %r{spec/presenters}}  # See RailsCast 287. This makes view available as local variable
  end

end

Spork.each_run do
  puts "SPORK EACH RUN"
  # This code will be run each time you run your specs.
  ActiveSupport::Dependencies.clear
  ActiveRecord::Base.instantiate_observers

  FactoryGirl.reload

  load "#{Rails.root}/config/routes.rb"
  Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.




# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Helpers just for testing
  def regexcape(s)
    Regexp.new(Regexp.escape(s))
  end

  def controller_sign_in
    @user = User.create(email: 'test@example.com', password: 'passxxx', username: 'SomeUser')
    sign_in @user
    return @user
  end

  # Called by fill_all_inputs to determine the set of columns (fields) to be included
  def columns_for_fill_all_inputs(model, options={})
    target_columns = model.content_columns
    if options[:include]
      target_columns.keep_if {|c| options[:include].include? c.name}
    end
    if options[:exclude]
      target_columns.delete_if {|c| options[:exclude].include? c.name}
    end
    return target_columns
  end

  # fill_all_inputs(Visit)
  # fill_all_inputs(Visit, exclude: [:hiv_status])
  # fill_all_inputs(Visit, include: [:height, :weight, :date])
  # fill_all_inputs(Visit, warn: true)
  def fill_all_inputs(model, options={})
    verbose = options[:verbose]
    warnings = options[:warnings]
    model_name = model.to_s.downcase
    not_found = []
    not_filled = []
    filled_values = {}
    columns = columns_for_fill_all_inputs(model, options)
    columns.each do |column|
      column_name = column.name
      field_id = "##{model_name}_#{column_name}"
      if page.has_selector?(field_id)
        filled_value = fill_in_column(model_name, column,
                                      (options[column_name.to_sym] || options[column_name]))
        if filled_value
          filled_values[column_name] = filled_value
          puts "Filling in #{column_name} with #{filled_value}" if verbose
        else
          not_filled << column_name
        end
      else
        not_found << column_name
      end
    end
    if verbose || warnings
      puts "Columns for #{model_name} not found in form: #{not_found}" if not_found.any?
      puts "Columns for #{model_name} found but not filled: #{not_filled}" if not_filled.any?
    end
    return filled_values
  end

  # Called by fill_all_inputs to fill in given input
  def fill_in_column(model_name, column, value=nil)
    field_name = "#{model_name}[#{column.name}]"
    value ||= case column.type
              when :datetime, :date then Date.today - 1.day
              when :string, :text then "Data for #{column.name}"
              when :integer then 5
              when :float then 40
              when :boolean then true
              else nil
            end
    if value == true
      check field_name
    elsif value
      fill_in(field_name, with: value)
    end
    return value
  end

  def check_all_equal(record, attributes)
#puts attributes
    mismatched=[]
    record.reload
    attributes.each do |name, value|
      if  record.send(name) != value
        mismatched << {name: name, found: record.send(name), expected: value}
      end
    end
    if mismatched.any?
      puts "Attributes for #{record} do not match expected:"
      mismatched.each {|m| puts "\t#{m[:name]}: expected #{m[:expected]} but got #{m[:found]}"}
    end
    return mismatched.empty?
  end
end
