class CharacterSerializer < ActiveModel::Serializer
  belongs_to :player
  attributes :id, :player_id, :hp, :ability, :alliance, :location, :name, :win_condition
end
