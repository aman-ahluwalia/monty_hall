class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.references :user, foreign_key: true
      t.integer :jackpot_door
      t.integer :status, :default => 0
      t.integer :prize, :default => 1000000

      t.timestamps
    end
  end
end
