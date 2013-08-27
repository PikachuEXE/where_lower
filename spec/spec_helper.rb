require 'coveralls'
Coveralls.wear!('rails')

require 'active_record'
require 'where_lower'
require 'database_cleaner'
require 'logger'

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
  :adapter => "sqlite3",
  :database => ":memory:"
)

# create tables
ActiveRecord::Schema.define(:version => 1) do
  create_table :parents do |t|
    t.string :name
    t.text :description
    t.integer :age, null: false, default: 21
    t.boolean :is_minecraft_lover, default: true

    t.timestamps
  end

  create_table :chirdren do |t|
    t.string :name
    t.text :description
    t.integer :age, null: false, default: 0
    t.boolean :is_minecraft_lover, default: true

    t.integer :parent_id

    t.timestamps
  end
end

class ActiveRecord::Base
  def self.silent_set_table_name(name)
    self.table_name = name
  end
end

# setup models

class Parent < ActiveRecord::Base
  has_many :children, inverse_of: :parent
end

class Child < ActiveRecord::Base
  belongs_to :parent, inverse_of: :children, touch: true
end
