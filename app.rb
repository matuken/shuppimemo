#encoding: utf-8
#

if development?
	require 'sinatra/reloader'
end

Sequel::Model.plugin(:schema)

Sequel.sqlite('db/shuppiMemo.db')
class Entries < Sequel::Model
	plugin :timestamps, :update_on_create => true
	unless table_exists?
		set_schema do
			primary_key :id
			string :mokuteki
			date  :date
			int :kingaku
			string :currency
			string :siharaisaki
			timestamp :created_at
			timestamp :updated_at
		end
		create_table
	end
end

get '/' do
	@index = 'shuppiMemo - TOP'
	@entries = Entries.all
	haml :index
end

post '/meisai' do
	@index = 'shuppiMemo - meisai'
	@id = params[:id]
	@mokuteki = params[:mokuteki]
	@date = params[:date]
	@kingaku = params[:kingaku]
	@currency = params[:currency]
	@siharaisaki = params[:siharaisaki]
	haml :meisai
end

post '/delkaku' do
	@index = 'shuppiMemo - delete'
	@id = params[:id]
	@mokuteki = params[:mokuteki]
	@date = params[:date]
	@kingaku = params[:kingaku]
	@currency = params[:currency]
	@siharaisaki = params[:siharaisaki]
	haml :delkaku
end


post '/add' do
	@entry = Entries.new  \
	                     :mokuteki => Sanitize.clean(params[:mokuteki]), :date => Sanitize.clean(params[:date]), \
                         :kingaku => Sanitize.clean(params[:kingaku]), :currency => Sanitize.clean(params[:currency]), \
						 :siharaisaki => Sanitize.clean(params[:siharaisaki])

	@entry.save
	redirect '/'
end

post '/update' do
	@entry = Entries[params[:id]]
	@entry.set({ :mokuteki => Sanitize.clean(params[:mokuteki]), :date => Sanitize.clean(params[:date]), \
                 :kingaku => Sanitize.clean(params[:kingaku]), :currency => Sanitize.clean(params[:currency]), \
		    	 :siharaisaki => Sanitize.clean(params[:siharaisaki]) })

	@entry.save
	redirect '/'
end

post '/delete' do
	@entry = Entries[params[:id]]
	@entry.destroy
	redirect '/'
end


helpers do
	def timefmt(time)
		if time
			time.strftime("%Y-%m-%d")
		else
			''
		end
	end
end

