class CreateEntries < Sequel::Migration 
  def up 
    create_table :entries do
      primary_key   :id
      String        :mokuteki
      Date          :date 
	  Int           :kingaku
	  String        :currency
	  String        :siharaisaki
	  String        :shudan
	  String        :himoku
      DateTime      :created_at
	  DateTime      :updated_at
    end
  end

  def down
    drop_table :entries
  end
end
