class Game < ApplicationRecord
  belongs_to :user

  enum status: {
    initial: 0,
    mid: 1,
    finish: 2
  }
end
