class RenameGoogleUidColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :google_uid, :google_oauth2_uid
  end
end
