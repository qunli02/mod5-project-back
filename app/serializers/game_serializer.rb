class GameSerializer < ActiveModel::Serializer
  has_many :players
  attributes :id, :turn
end
