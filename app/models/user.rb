class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :photos, dependent: :destroy
  #has_many :tags
  validates :name, presence: true
  validates :profile, length: { maximum: 200 }

  # 以下追記

  # image_topメソッドとimagesメソッドを使用できるようにする。
  has_one_attached :image_top
  has_many_attached :images

 # Active Storageのバリデーション
  validates :image_top, :images, content_type: { in: %w[image/jpeg image/gif image/png],
                                   message: "must be a valid image format" },
                                size: { less_than: 5.megabytes,    
                                        message: "should be less than 5MB" }
  
 # image_top のリサイズ済み画像を返す
  def resize_image_top
    image_top.variant(resize_to_limit: [500, 200])
  end

end
