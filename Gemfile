source 'https://rubygems.org'
gem "chef", '~> 13.12.14'

gem 'berkshelf', '~> 4.0'

group :integration do
  gem 'test-kitchen', '~> 2.3'
  gem 'foodcritic'
end

group :docker do
  gem 'kitchen-docker', git: 'https://github.com/test-kitchen/kitchen-docker', ref: 'b45c4858bef19f22a32096e44777bff097f35dd8'
end
