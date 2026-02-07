class TodoItem < ApplicationRecord
  belongs_to :todo

  validates :name, presence: true
end
