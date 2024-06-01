class AddPhotoIdToPhotos < ActiveRecord::Migration[6.1]
  def change
    add_column :photos, :photo_id, :integer
  end
end
