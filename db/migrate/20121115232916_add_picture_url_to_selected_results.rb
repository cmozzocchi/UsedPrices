class AddPictureUrlToSelectedResults < ActiveRecord::Migration
  def change
    add_column :searches, :pictureUrl, :string
  end
end
