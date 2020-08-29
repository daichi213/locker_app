class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :user_id
      t.integer :baggage_request_to_user_id
      t.integer :read_flag
      t.integer :del_flag

      t.timestamps
    end
  end
end
