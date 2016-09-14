class AddReferencesToModel < ActiveRecord::Migration
  def change
    add_foreign_key :models, :makes
  end
end
