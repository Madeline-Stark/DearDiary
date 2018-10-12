class CreateEntriesTable < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :content
      t.string :date
      t.integer :user_id
    end
  end
end
