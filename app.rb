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
	date_yyyymm = date_now.split(/-/)
	date_from = date_now + "-01"
	case date_yyyymm[1] 
	when "01", "03", "05", "07", "08", "10", "12"
	  date_to = date_now + "-31"
	when "04", "06", "09", "11"
	  date_to = date_now + "-30"
	when "02"
	  if date_yyyymm[0].to_i % 4 == 0
	    date_to = date_now + "-29"
	  else
		date_to = date_now + "-28"
	  end
    end
    @entries = Entries.filter(:date => date_from..date_to).order(:date).all
    @sum = Entries.filter(:date => date_from..date_to).sum(:kingaku)
	haml :list
end

get '/himoku/:himokuname' do
	@index = 'shuppiMemo - himoku(This month)'
	date_now = Time.now.strftime("%Y-%m")
	@date = date_now
#	date_yyyymm = date_now.split(/-/)
    date_from = date_now + "-01"
#	case date_yyyymm[1] 
#	when "01", "03", "05", "07", "08", "10", "12"
#	  date_to = date_now + "-31"
#	when "04", "06", "09", "11"
#	  date_to = date_now + "-30"
#	when "02"
#	  if date_yyyymm[0].to_i % 4 == 0
#	    date_to = date_now + "-29"
#	  else
#		date_to = date_now + "-28"
#	  end
#   end
	date_to = adddate(date_now)
	@himoku = params[:himokuname]
    dataset = Entries.filter(:date => date_from..date_to)
    @entries = dataset.filter(:himoku => params[:himokuname]).order(:date).all
    @sum = dataset.filter(:himoku => params[:himokuname]).sum(:kingaku)
	haml :himoku
end

get '/himoku/:himokuname/:yyyymm' do
	@index = 'shuppiMemo - himoku'
	date_now = params[:yyyymm]
	@date = date_now
#   date_yyyymm = date_now.split(/-/)
	date_from = date_now + "-01"
#   case date_yyyymm[1] 
#	when "01", "03", "05", "07", "08", "10", "12"
#	  date_to = date_now + "-31"
#	when "04", "06", "09", "11"
#	  date_to = date_now + "-30"
#	when "02"
#	  if date_yyyymm[0].to_i % 4 == 0
#	    date_to = date_now + "-29"
#	  else
#		date_to = date_now + "-28"
#	  end
#   end
	date_to = adddate(date_now)
	@himoku = params[:himokuname]
    dataset = Entries.filter(:date => date_from..date_to)
    @entries = dataset.filter(:himoku => params[:himokuname]).order(:date).all
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
	def adddate(yyyymm)
		if yyyymm
	        tmp_yyyymm = yyyymm.split(/-/)
	        case tmp_yyyymm[1] 
	        when "01", "03", "05", "07", "08", "10", "12"
	          yyyymm + "-31"
	        when "04", "06", "09", "11"
	          yyyymm + "-30"
	        when "02"
	          if tmp_yyyymm[0].to_i % 4 == 0
	            yyyymm + "-29"
	          else
		        yyyymm + "-28"
	          end
            end
		end
	end
end


