class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy, foreign_key: 'tag_id'
  has_many :photos, through: :tag_maps
  belongs_to :user # 追記
end
