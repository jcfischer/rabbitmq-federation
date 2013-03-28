require "rubygems"
require "amqp"


require 'json'
require 'awesome_print'


require 'logger'

ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined? ROOT_DIR


Dir[File.join(ROOT_DIR, 'app', '*.rb')].each do |lib|
  require lib
end