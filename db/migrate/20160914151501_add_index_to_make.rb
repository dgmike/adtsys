class AddIndexToMake < ActiveRecord::Migration
  def change
    add_index :makes, :name, unique: true
    add_index :makes, :webmotors_id
  end
end
