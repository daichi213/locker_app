class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :leaver_id
      t.integer :receiver_id
      t.integer :leaver_authenticate
      t.integer :receiver_authenticate
      t.datetime :started_at
      t.datetime :terminated_at
      t.decimal :leaver_point
      t.decimal :receiver_point
      t.integer :required_id
      t.integer :del_flag

      t.timestamps
    end
  end
end
