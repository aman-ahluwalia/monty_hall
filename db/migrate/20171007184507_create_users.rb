class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.integer :max_score
      t.integer :total_score
      t.integer :number_of_times

      t.timestamps
    end
  end
end
