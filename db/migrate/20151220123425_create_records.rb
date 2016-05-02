class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.text :content, null: false
      t.text :reference
      t.text :memo
      t.integer :assocation, null: false, default: 0
      t.integer :later, null: false, default: 0

      t.timestamps null: false
    end
  end
end
