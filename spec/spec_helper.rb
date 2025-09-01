# frozen_string_literal: true

if ENV["COVERALLS"]
  require "simplecov"
  require "simplecov-lcov"

  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = "coverage/lcov.info"
  end

  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
    [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::LcovFormatter]
  )

  SimpleCov.start do
    add_filter "spec/"
  end
end

# Workaround for uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger
require "logger"

require "active_record"
require "where_lower"

require "database_cleaner"
require "logger"

require "rspec"
require "rspec/its"

# ActiveRecord::Base.logger = Logger.new(STDOUT) # for easier debugging

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end

# connect
ActiveRecord::Base.establish_connection(
  adapter:  "sqlite3",
  database: ":memory:",
)

# create tables
ActiveRecord::Schema.define(version: 1) do
  create_table :parents do |t|
    t.string :name
    t.text :description
    t.integer :age, null: false, default: 0
    t.boolean :is_minecraft_lover, default: true

    t.timestamps(null: false)
  end

  create_table :children do |t|
    t.string :name
    t.text :description
    t.integer :age, null: false, default: 0
    t.boolean :is_minecraft_lover, default: true

    t.integer :parent_id

    t.timestamps(null: false)
  end

  create_table :grand_children do |t|
    t.string :name
    t.text :description
    t.integer :age, null: false, default: 0
    t.boolean :is_minecraft_lover, default: true

    t.integer :child_id

    t.timestamps(null: false)
  end
end

module ActiveRecord
  class Base
    def self.silent_set_table_name(name)
      self.table_name = name
    end
  end
end

# setup models

class Parent < ActiveRecord::Base
  has_many :children, inverse_of: :parent

  scope :latest_first, proc { order("created_at DESC") }
  def self.earliest_first
    order(:created_at)
  end
end

class Child < ActiveRecord::Base
  belongs_to :parent, inverse_of: :children, touch: true
  has_many :grand_children, inverse_of: :child

  validates_presence_of :parent
end

class GrandChild < ActiveRecord::Base
  belongs_to :child, inverse_of: :grand_children, touch: true

  validates_presence_of :child
end
