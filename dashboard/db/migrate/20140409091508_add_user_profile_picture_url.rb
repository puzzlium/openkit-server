class AddUserProfilePictureUrl < ActiveRecord::Migration
  def change
    add_column :users, :profile_picture_url, :string, :limit => 1024
  end
end
