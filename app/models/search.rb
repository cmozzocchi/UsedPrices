class Search < ActiveRecord::Base
  attr_accessible :keyword, :selectedUPC, :selectedRefID, :zipcode, :distance, :user_id, :selectedISBN 

  belongs_to :user

  validates :keyword, presence: true, length: {minimum: 2}
end
