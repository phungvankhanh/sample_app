class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_by_desc, ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content}
  validate :picture_size

  private
  def picture_size
    return if picture.size <= Settings.size_image.megabytes
    errors.add(:picture, I18n.t("shoud_less_5_MB", size: Settings.size_image))
  end
end
