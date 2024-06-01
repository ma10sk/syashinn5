class Photo < ApplicationRecord
  belongs_to :user

  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps

  has_one_attached :image_top
  has_many_attached :images


  validates :image_top, :images, content_type: { in: %w[image/jpeg image/gif image/png],
                                   message: "must be a valid image format" },
                                size: { less_than: 5.megabytes,    
                                        message: "should be less than 5MB" }
                
  attr_accessor :tag_name # 追記

  after_destroy :cleanup_unused_tags # 追記

    def resize_image_top
      image_top.variant(resize_to_limit: [500, 200])
    end

    
    def save_tag(sent_tags)
        current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
        old_tags = current_tags - sent_tags
        new_tags = sent_tags - current_tags
   
        old_tags.each do |old|
          self.tags.delete Tag.find_by(tag_name: old)
        end
   
        new_tags.each do |new|
          new_photo_tag = Tag.find_or_create_by(tag_name: new)
          self.tags << new_photo_tag
        end
    end

  private #追記
  def cleanup_unused_tags
    unused_tags = Tag.left_outer_joins(:tag_maps)
                     .group('tags.id')
                     .having('COUNT(tag_maps.id) = 0')
    unused_tags.each do |tag|
      puts "Deleting unused tag: #{tag.tag_name}"
      tag.destroy
    end
  end

  
end