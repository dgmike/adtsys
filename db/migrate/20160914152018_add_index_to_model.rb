class AddIndexToModel < ActiveRecord::Migration
  def change
    add_index :models, [:name, :make_id], unique: true
  end
end
