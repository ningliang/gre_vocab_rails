class WordSet < ActiveRecord::Base  
  has_and_belongs_to_many :words
  
  BY_ALPHA = "alpha"
  BY_LENGTH = "length"
end
