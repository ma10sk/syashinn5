class RemovePhotoIdFromPhotos < ActiveRecord::Migration[6.1]
  def change
    remove_column :photos, :photo_id, :integer
  end
end
