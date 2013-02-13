#encoding: utf-8
#

if development?
	require 'sinatra/reloader'
end

#Sequel::Model.plugin(:schema)

Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/shuppiMemo.db')
class Entries < Sequel::Model
	plugin :timestamps, :update_on_create => true
#	unless table_exists?
#		set_schema do
#			primary_key :id
#			string :mokuteki
#			date  :date
#			int :kingaku
#			string :currency
#			string :siharaisaki
#			string :shudan
#			timestamp :created_at
#3			timestamp :updated_at
#		end
#		create_table
#end
end

get '/' do
	@index = 'shuppiMemo - TOP'
	date_now = timefmt(Time.now)
	@date = date_now
#   @entries = Entries.all
    @entries = Entries.filter(:date => date_now).all
	haml :index
end

get '/date/:yyyymmdd' do
	@index = 'shuppiMemo - daily'
	date_now = params[:yyyymmdd]
	@date = date_now
    @entries = Entries.filter(:date => date_now).all
    @sum = Entries.filter(:date => date_now).sum(:kingaku)
	haml :list
end

get '/month/:yyyymm' do
	@index = 'shuppiMemo - monthly'
	date_now = params[:yyyymm]
	@date = date_now
	date_from = date_now + "-01"
	date_to = date_now + "-31"
    @entries = Entries.filter(:date => date_from..date_to).all
    @sum = Entries.filter(:date => date_from..date_to).sum(:kingaku)
	haml :list
end

get '/himoku/:himokuname' do
	@index = 'shuppiMemo - himoku(This month)'
	date_now = Time.now.strftime("%Y-%m")
	@date = date_now
	date_from = date_now + "-01"
	date_to = date_now + "-31"
	@himoku = params[:himokuname]
    dataset = Entries.filter(:date => date_from..date_to)
    @entries = dataset.filter(:himoku => params[:himokuname]).all
    @sum = dataset.filter(:himoku => params[:himokuname]).sum(:kingaku)
	haml :himoku
end

post '/meisai' do
	@index = 'shuppiMemo - meisai'
	@id = params[:id]
	@mokuteki = params[:mokuteki]
	@date = params[:date]
	@kingaku = params[:kingaku]
	@currency = params[:currency]
	@siharaisaki = params[:siharaisaki]
	@shudan = params[:shudan]
	@himoku = params[:himoku]
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
	@shudan = params[:shudan]
	@himoku = params[:himoku]
	haml :delkaku
end


post '/add' do
	@entry = Entries.new :mokuteki => Sanitize.clean(params[:mokuteki]), :date => Sanitize.clean(params[:date]),  :kingaku => Sanitize.clean(params[:kingaku]), :currency => Sanitize.clean(params[:currency]),  :siharaisaki => Sanitize.clean(params[:siharaisaki]) , :shudan => Sanitize.clean(params[:shudan]), :himoku => Sanitize.clean(params[:himoku])  
#                        :mokuteki => Sanitize.clean(params[:mokuteki]), :date => Sanitize.clean(params[:date]), \
#                        :kingaku => Sanitize.clean(params[:kingaku]), :currency => Sanitize.clean(params[:currency]), \
#                        :siharaisaki => Sanitize.clean(params[:siharaisaki]) , :shudan => Sanitize.clean(params[:shudan]), \
#                        :himoku => Sanitize.clean(params[:himoku]) 

	@entry.save
	redirect '/'
end

post '/update' do
	@entry = Entries[params[:id]]
	@entry.set({ :mokuteki => Sanitize.clean(params[:mokuteki]), :date => Sanitize.clean(params[:date]), :kingaku => Sanitize.clean(params[:kingaku]), :currency => Sanitize.clean(params[:currency]), :siharaisaki => Sanitize.clean(params[:siharaisaki]), :shudan => Sanitize.clean(params[:shudan]), :himoku => Sanitize.clean(params[:himoku]) })

#                :kingaku => Sanitize.clean(params[:kingaku]), :currency => Sanitize.clean(params[:currency]), \
#           	 :siharaisaki => Sanitize.clean(params[:siharaisaki]), :shudan => Sanitize.clean(params[:shudan]), \
#                :himoku => Sanitize.clean(params[:himoku]) })

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


