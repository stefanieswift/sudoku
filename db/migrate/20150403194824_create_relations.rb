class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :group_id
      t.integer :user_id
    end
  end
end
