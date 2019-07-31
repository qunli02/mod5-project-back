class Game < ApplicationRecord
  has_many :players
  serialize :field
end
