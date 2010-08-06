require "test/unit"
require "rubygems"
require "active_record"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Base.logger = Logger.new(STDOUT)

require File.join(File.dirname(__FILE__), '../lib/validates_email_format_of')

require File.join(File.dirname(__FILE__), '../init')

I18n.locale = :en

I18n.load_path << File.join(File.dirname(__FILE__), '/locales/en.yml')

def setup_db
   ActiveRecord::Schema.define do
      create_table("users", :force => true) do | t |
         t.column("id", :integer)
         t.column("email", :string)
      end
   end
   User.create(:email => "amed@tractical.com")
end

def teardown_db
   ActiveRecord::Base.connection.tables.each do | table |
      ActiveRecord::Base.connection.drop_table(table)
   end
end

class User < ActiveRecord::Base; end

class UserOne < User
   validates_email_format_of(:email)
end

class UserTwo < User
   validates_email_format_of(:email, :invalid_domains => %w[gmail.com hotmail.com])
end