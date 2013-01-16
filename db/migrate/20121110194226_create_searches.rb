class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|

      t.string  :keyword,             :null => false, :default => ""
      t.string  :selectedUPC
      t.string  :selectedRefID
      t.string  :zipcode
      t.string  :distance,            :null => true,  :default => 500 
      t.integer :user_id

      t.timestamps
    end
  end
end
