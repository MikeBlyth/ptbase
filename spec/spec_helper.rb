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

  def fill_all_inputs(model, options={})
    verbose = options[:verbose]
    warnings = options[:warnings]
    model_name = model.to_s.downcase
    not_found = []
    not_filled = []
    target_columns = model.content_columns
    if options[:exclude]
      target_columns.delete_if {|c| options[:exclude].include? c.name}
    end
    model.content_columns.each do |column|
      field_id = "##{model_name}_#{column.name}"
      if page.has_selector?(field_id)
        field_name = "#{model_name}[#{column.name}]"
        value = case column.type
                  when :datetime, :date then Date.today - 1.day
                  when :string, :text then "Data for #{column.name}"
                  when :integer then "5"
                  when :float then "4.0"
                  when :boolean then :boolean
                  else nil
                end
        not_filled << column.name unless value
        puts "Filling in #{field_name} with #{value}" if value && verbose
        if value == :boolean
          check field_name
        else
          fill_in(field_name, with: value) if value
        end
      else
        not_found << column.name
      end
    end
    if verbose || warnings
      puts "Columns not found in form: #{not_found}"
      puts "Columns found but not filled: #{not_filled}"
    end

  end


end
