#encoding: utf-8
#

if development?
	require 'sinatra/reloader'
end

Sequel::Model.plugin(:schema)

Sequel.sqlite('db/kakeiboMemo.db')
class Entries < Sequel::Model
	plugin :timestamps, :update_on_create => true
	unless table_exists?
		set_schema do
			primary_kei :id
			string :mokuteki
			timestamp :created_at
			timestamp :updated_at
		end
		create_table
	end
end

get '/' do
	@index = 'kakeiboMemo - TOP'
	@entries = Entries.all
	haml :index
end

post '/add' do
	@entry = Entries.new :mokuteki => Sanitize.clean(params[:mokuteki])
	@entry.save
	redirect '/'
end

helpers do
	def timefmt(time)
		if time
			time.strftime("%Y-%m-%d %H:%M:%S")
		else
			''
		end
	end
end


