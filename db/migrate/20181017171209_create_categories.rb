class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :budget_amount #in pence/cents
      t.string :budget_timeframe
      t.integer :user_id

      t.timestamps
    end
  end
end
