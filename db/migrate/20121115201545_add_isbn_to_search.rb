class AddIsbnToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :selectedISBN, :string
  end
end
