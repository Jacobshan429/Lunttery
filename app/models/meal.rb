class Meal < ApplicationRecord
	belongs_to :dinner
	belongs_to :style
	validates_presence_of :name
end