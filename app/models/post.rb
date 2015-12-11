class Post < ActiveRecord::Base

mount_uploader :image, ImageUploader

belongs_to :user

validates_presence_of :url

validates :audio, presence: true, unless: ->(user){user.audio_link.present?}
validates :audio_link, presence: true, unless: ->(user){user.audio.present?}

end
