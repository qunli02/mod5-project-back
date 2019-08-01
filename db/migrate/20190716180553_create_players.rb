class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.integer :game_id
      t.text :name
      t.text :color

      t.timestamps
    end
  end
end
