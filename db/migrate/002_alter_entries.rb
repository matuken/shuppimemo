class CreateEntries < Sequel::Migration 
  def up 
    alter_table :entries do
	  add_column :himoku , String 
    end
  end

  def down
    alter_table :entries do
		drop_column :himoku
	end
  end
end
