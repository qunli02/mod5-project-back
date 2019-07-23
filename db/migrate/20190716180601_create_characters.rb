class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.integer :player_id
      t.integer :hp
      t.text :ability
      t.text :alliance

      t.timestamps
    end
  end
end
