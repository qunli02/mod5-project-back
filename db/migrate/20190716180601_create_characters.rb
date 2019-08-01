class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.text :name
      t.text :win_condition
      t.integer :player_id
      t.integer :hp
      t.integer :damage, default:0
      t.text :ability
      t.text :alliance
      t.integer :location
      t.text :hermit, default: nil


      t.timestamps
    end
  end
end
