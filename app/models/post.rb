class Post < ActiveRecord::Base

acts_as_taggable
paginates_per 5

extend FriendlyId
friendly_id :title, use: :slugged

before_validation :set_default_title

mount_uploader :image, ImageUploader
mount_uploader :banner, ImageUploader

has_many :listens, :dependent => :destroy
has_many :listeners, through: :listens, :source => :user

has_many :user_favs
has_many :favourited_by, through: :user_favs, :source => :user
has_many :favourites, through: :user_favs, :source => :user

belongs_to :user

# validates_presence_of :url	
# validates_presence_of :title	

validates :title, presence: true, unless: ->(user){user.url.present?}
validates :url, presence: true, unless: ->(user){user.title.present?}

validates :audio, presence: true, unless: ->(user){user.audio_link.present?}
validates :audio_link, presence: true, unless: ->(user){user.audio.present?}

validates :url, :format => URI::regexp(%w(http https)), :allow_blank => true
validates :audio_link, :format => URI::regexp(%w(http https))

validate :file_extenstion

def hot_score
  self.plays.to_i/10 + self.favourites.count.to_i + 2 * self.embeds.to_i
end

def self.sorted_by_score
  Post.all.sort_by(&:hot_score)
end

def file_extenstion

	if	File.extname(URI.parse(self.audio_link).path) != ".mp3"
	  errors.add(:audio_link, "must be .mp3 url")
    end
end

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
