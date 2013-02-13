require 'rubygems'
require 'sinatra'
require 'haml'
require 'sequel'
require 'sanitize'
 
if development?
	require 'sqlite3'
end

if production?
	require 'pg'
end

require './app.rb'

run Sinatra::Application

