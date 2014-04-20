source 'http://rubygems.org'

gemspec

gem "rake",  ">= 0.8.7"
gem 'mocha', '>= 0.13.0', :require => false

gem "pry"

group :doc do
  gem "rdoc",  "~> 3.4"
  gem "horo",  "= 1.0.3"
  gem "RedCloth", "~> 4.2" if RUBY_VERSION < "1.9.3"
end

# for perf tests
gem "faker"
gem "rbench"
gem "addressable"

# AS
gem "memcache-client", ">= 1.8.5"

platforms :ruby do
  gem 'json'
  gem 'yajl-ruby'
  gem "nokogiri", ">= 1.4.4"

  # AR
  gem "sqlite3", "~> 1.3.3"

  gem 'bcrypt-ruby', '~> 3.0.0'

  group :db do
    gem "pg", ">= 0.9.0"
    gem "mysql", ">= 2.8.1"
    gem "mysql2", :git => "git://github.com/brianmario/mysql2.git", :branch => "0.2.x"
  end
end

env :AREL do
  gem "arel", :path => ENV['AREL']
end

# gems that are necessary for ActiveRecord tests with Oracle database
if ENV['ORACLE_ENHANCED_PATH'] || ENV['ORACLE_ENHANCED']
  platforms :ruby do
    gem 'ruby-oci8', ">= 2.0.4"
  end
  if ENV['ORACLE_ENHANCED_PATH']
    gem 'activerecord-oracle_enhanced-adapter', :path => ENV['ORACLE_ENHANCED_PATH']
  else
    gem "activerecord-oracle_enhanced-adapter", :git => "git://github.com/rsim/oracle-enhanced.git"
  end
end
