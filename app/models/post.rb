class Post < ActiveRecord::Base

acts_as_taggable


extend FriendlyId
  friendly_id :title, use: :slugged

mount_uploader :image, ImageUploader


belongs_to :user

validates_presence_of :url	
validates_presence_of :title	

validates_presence_of :url

validates :audio, presence: true, unless: ->(user){user.audio_link.present?}
validates :audio_link, presence: true, unless: ->(user){user.audio.present?}

validates :url, :format => URI::regexp(%w(http https))
validates :audio_link, :format => URI::regexp(%w(http https))


end
