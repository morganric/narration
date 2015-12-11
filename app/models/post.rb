class Post < ActiveRecord::Base

acts_as_taggable

mount_uploader :image, ImageUploader


belongs_to :user

validates_presence_of :url	
validates_presence_of :title	

validates_presence_of :url

validates :audio, presence: true, unless: ->(user){user.audio_link.present?}
validates :audio_link, presence: true, unless: ->(user){user.audio.present?}

extend FriendlyId
  friendly_id :title, use: :slugged

end
