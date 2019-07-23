class CharacterSerializer < ActiveModel::Serializer
  belongs_to :player
  attributes :id, :player_id, :hp, :ability, :alliance
end
