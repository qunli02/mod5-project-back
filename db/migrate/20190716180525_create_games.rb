class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :turn
      t.integer :wight
      t.text :field

      t.timestamps
    end
  end
end
