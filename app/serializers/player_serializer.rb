class PlayerSerializer < ActiveModel::Serializer
  belongs_to :game
  has_one :character
  attributes :id, :game_id, :name
end
