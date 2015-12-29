class Post < ActiveRecord::Base

acts_as_taggable
paginates_per 5

extend FriendlyId
  friendly_id :title, use: :slugged

   before_validation :set_default_title

mount_uploader :image, ImageUploader


belongs_to :user

validates_presence_of :url	
validates_presence_of :title	


validates :audio, presence: true, unless: ->(user){user.audio_link.present?}
validates :audio_link, presence: true, unless: ->(user){user.audio.present?}

validates :url, :format => URI::regexp(%w(http https))
validates :audio_link, :format => URI::regexp(%w(http https))

def should_generate_new_friendly_id?
  new_record? || slug.blank?
end

private

    def set_default_title
      self.title ||= "post#{Post.maximum(:id).next}"
    end

    def should_generate_new_friendly_id?
      slug.blank? || title_changed?
    end

end
